import 'package:src/data/model/create_note_model.dart';
import 'package:src/domain/repository/notes_repository.dart';

class CreateNoteUseCase {
  final NotesRepository notesRepository;

  CreateNoteUseCase(this.notesRepository);
  Future<CreateNoteModel> call(
      {required int patientId,
      required int baseNoteId,
      required String noteBody}) async {
    return notesRepository.createNote(patientId, baseNoteId, noteBody);
  }
}
