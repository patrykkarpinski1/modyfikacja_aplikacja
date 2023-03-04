part of 'notepad_cubit.dart';

class NotepadState {
  final List<NoteModel> notes;
  final bool removingErrorOccured;
  final Status status;
  final String? errorMessage;

  const NotepadState({
    this.notes = const [],
    this.removingErrorOccured = false,
    this.status = Status.initial,
    this.errorMessage = '',
  });
}
