import 'package:src/domain/repository/notes_repository.dart';

class UpdateSeenAtByPatientUseCase {
  final NotesRepository notesRepository;

  UpdateSeenAtByPatientUseCase(this.notesRepository);
  Future<dynamic> call({required int patientId}) async {
    return notesRepository.updateSeenAtByPatient(patientId);
  }
}