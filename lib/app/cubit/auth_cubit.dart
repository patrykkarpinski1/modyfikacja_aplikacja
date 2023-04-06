import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:modyfikacja_aplikacja/app/core/enums.dart';
import 'package:modyfikacja_aplikacja/repositories/login_repositories.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._loginRepository) : super(const AuthState());
  final LoginRepository _loginRepository;

  Future<void> passwordReset({
    required String email,
  }) async {
    try {
      await _loginRepository.passwordReset(email: email);
      emit(const AuthState(
          status: Status.success,
          message: 'Password reset link sent! Please check your email '));
    } on FirebaseAuthException catch (error) {
      emit(AuthState(
          status: Status.error, errorMessage: error.message.toString()));
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return await FirebaseAuth.instance
        .signInWithCredential(credential)
        .whenComplete(() {
      users.doc(FirebaseAuth.instance.currentUser!.uid).set({
        'name': googleUser!.displayName,
        'profile_image': googleUser.photoUrl,
      });
    });
  }

  Future<void> signOut() async {
    try {
      await _loginRepository.signOut();
      emit(
        const AuthState(status: Status.success),
      );
    } on FirebaseAuthException catch (error) {
      emit(AuthState(
          status: Status.error, errorMessage: error.message.toString()));
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password.trim() != confirmPassword.trim()) {
      emit(
        const AuthState(
          status: Status.error,
          errorMessage: 'Passwords don\'t match',
          isCreatingAccount: true,
        ),
      );
    } else {
      try {
        await _loginRepository.register(email: email, password: password);
        emit(const AuthState(isCreatingAccount: false));
        try {
          await _loginRepository.sendEmailVerification();
        } on FirebaseAuthException catch (error) {
          emit(AuthState(
              status: Status.error, errorMessage: error.message.toString()));
        }
      } on FirebaseAuthException catch (error) {
        emit(AuthState(
          status: Status.error,
          errorMessage: error.message.toString(),
          isCreatingAccount: true,
        ));
      }
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user?.emailVerified == false) {
        emit(const AuthState(
          status: Status.success,
          message: 'please check your inbox and verify your email',
        ));
      }
    } on FirebaseAuthException catch (error) {
      emit(AuthState(
          status: Status.error, errorMessage: error.message.toString()));
    }
  }

  Future<void> creatingAccount() async {
    emit(
      const AuthState(
        user: null,
        isCreatingAccount: true,
      ),
    );
  }

  Future<void> notCreatingAccount() async {
    emit(
      const AuthState(
        user: null,
        isCreatingAccount: false,
      ),
    );
  }

  Future<void> addUserName({required String name}) async {
    try {
      await _loginRepository.addUserName(name: name);
    } catch (error) {
      emit(AuthState(status: Status.error, errorMessage: error.toString()));
    }
  }

  Future<void> addUserPhoto({
    required XFile image,
  }) async {
    try {
      await _loginRepository.addUserPhoto(image: image);
    } catch (error) {
      emit(AuthState(status: Status.error, errorMessage: error.toString()));
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _loginRepository.deleteAccount();
    } on FirebaseAuthException catch (error) {
      emit(AuthState(
          status: Status.error, errorMessage: error.message.toString()));
    }
  }

  Future<void> resendEmailVerification() async {
    try {
      await _loginRepository.sendEmailVerification();
    } on FirebaseAuthException catch (error) {
      emit(AuthState(
          status: Status.error, errorMessage: error.message.toString()));
    }
  }

  StreamSubscription? _streamSubscription;

  Future<void> start() async {
    try {
      emit(
        const AuthState(
          user: null,
          status: Status.loading,
          errorMessage: '',
          isCreatingAccount: false,
        ),
      );

      _streamSubscription =
          FirebaseAuth.instance.authStateChanges().listen((user) {
        emit(
          AuthState(
            status: Status.success,
            user: user,
          ),
        );
      });
    } on FirebaseAuthException catch (error) {
      emit(AuthState(
          status: Status.error, errorMessage: error.message.toString()));
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
