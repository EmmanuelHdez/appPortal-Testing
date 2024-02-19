import 'package:src/data/model/notes_model.dart';
import 'package:src/domain/repository/notes_repository.dart';

class FetchUnreadNotesUseCase {
  final NotesRepository notesRepository;
  
  FetchUnreadNotesUseCase(this.notesRepository);
  Future<NotesModel> call({required int patientId}) async {
    return notesRepository.fetchUnreadNotes(patientId);
  }
}
