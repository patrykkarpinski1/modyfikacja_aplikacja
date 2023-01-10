import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  AddTaskCubit() : super(AddTaskState());
  StreamSubscription? _streamSubscription;
  Future<void> start() async {
    emit(
      AddTaskState(
        errorMessage: '',
        textNote: '',
      ),
    );
  }

  Future<void> changetextNote(
    String newTextNote,
  ) async {
    emit(
      AddTaskState(textNote: newTextNote),
    );
  }

  Future<void> add(String text, Timestamp date) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').add({
        'text': text,
        'category_id': '',
        'date': date,
      });
      emit(
        AddTaskState(saved: true),
      );
    } catch (error) {
      emit(
        AddTaskState(
          errorMessage: error.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
