import 'package:dio/dio.dart';
import 'package:src/data/model/create_note_model.dart';
import 'package:src/data/model/notes_model.dart';
import 'package:src/errors/dioException.dart';
import 'package:src/infrastructure/service/notes_service.dart';

abstract class NotesRepository {
  Future<NotesModel> fetchUnreadNotes(int patientId);
  Future<CreateNoteModel> createNote(
      int patientId, int baseNoteId, String noteBody);
  Future<dynamic> markAsSeen(int noteId);
  Future<dynamic> updateSeenAtByPatient(int patientId);
}

class NotesModelImpl extends NotesRepository {
  final NotesService notesService;

  NotesModelImpl(this.notesService);

  @override
  Future<NotesModel> fetchUnreadNotes(int patientId) async {
    try {
      final request = await notesService.fetchUnreadNotes(patientId);
      return request;
    } on DioException catch (e) {
      throw resposeDioException(e, '');
    }
  }

  @override
  Future<CreateNoteModel> createNote(
      int patientId, int baseNoteId, String noteBody) async {
    try {
      final request =
          await notesService.createNote(patientId, baseNoteId, noteBody);
      return request;
    } on DioException catch (e) {
      throw resposeDioException(e, '');
    }
  }

  @override
  Future<dynamic> markAsSeen(int noteId) async {
    try {
      final request = await notesService.markAsSeen(noteId);
      return request;
    } on DioException catch (e) {
      throw resposeDioException(e, '');
    }
  }

  @override
  Future<dynamic> updateSeenAtByPatient(int patientId) async {
    try {
      final request = await notesService.updateSeenAtByPatient(patientId);
      return request;
    } on DioException catch (e) {
      throw resposeDioException(e, '');
    }
  }
}
