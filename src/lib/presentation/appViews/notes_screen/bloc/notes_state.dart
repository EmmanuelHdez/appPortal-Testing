part of 'notes_bloc.dart';

class NotesState extends Equatable {
  final String noteBody;
  const NotesState({
    this.noteBody = '',
  });

  NotesState copyWith({String? noteBody}) {
    return NotesState(noteBody: noteBody ?? this.noteBody);
  }

  @override
  List<Object?> get props => [noteBody];
}

class NotesInitial extends NotesState {}

class NotesLoading extends NotesState {}

class NotesDetailsLoading extends NotesState {}

class UnreadNotesLoaded extends NotesState {
  final NotesModel notesModel;
  final String patientName;
  const UnreadNotesLoaded(this.notesModel, this.patientName);

  @override
  List<Object> get props => [notesModel, patientName];
}

class NotesError extends NotesState {
  final dynamic message;

  const NotesError(this.message);
  @override
  List<Object?> get props => [message];
}

class NoteCreated extends NotesState {
  final CreateNoteModel result;
  const NoteCreated(this.result);

  @override
  List<Object> get props => [result];
}

class NoteMarkedAsSeen extends NotesState {
  final NoteModel noteData;
  final dynamic result;
  const NoteMarkedAsSeen(this.result, this.noteData);

  @override
  List<Object> get props => [result, noteData];
}

class FormTokenReceived extends NotesState {
  final Map<String, dynamic> form;
  final FormCollectionsTokenModel result;

  const FormTokenReceived(this.result, this.form);

  @override
  List<Object> get props => [result, form];
}