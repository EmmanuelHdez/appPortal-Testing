part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();
  @override
  List<Object> get props => [];
}

class NotesGetNoteId extends NotesEvent {
  final String keyName;

  const NotesGetNoteId(this.keyName);
  @override
  List<Object> get props => [keyName];
}

class FetchUnreadNotes extends NotesEvent {
  const FetchUnreadNotes();
  @override
  List<Object> get props => [];
}

class GetNoteText extends NotesEvent {
  final String noteBody;
  GetNoteText({required this.noteBody});
}

class CreateNote extends NotesEvent {
  final int baseNoteId;
  final String noteBody;
  const CreateNote(this.baseNoteId, this.noteBody);
  @override
  List<Object> get props => [baseNoteId, noteBody];
}

class MarkNoteAsSeen extends NotesEvent {
  final dynamic noteId;
  final NoteModel noteData;
  const MarkNoteAsSeen(this.noteId, this.noteData);
  @override
  List<Object> get props => [noteId, noteData];
}

class RequestFormToken extends NotesEvent {
  final int collectionId;
  final int patientId;
  final int userId;
  final bool isDoctor;
   final Map<String, dynamic> form;
  const RequestFormToken(this.collectionId, this.patientId, this.userId, this.isDoctor, this.form);
 @override
  List<Object> get props => [collectionId, patientId, userId, isDoctor, form];
}