import 'package:src/domain/repository/notes_repository.dart';

class MarkAsSeenUseCase {
  final NotesRepository notesRepository;

  MarkAsSeenUseCase(this.notesRepository);
  Future<dynamic> call({required int noteId}) async {
    return notesRepository.markAsSeen(noteId);
  }
}
