import 'package:src/data/model/past_appointments_model.dart';
import 'package:src/domain/repository/appointments_repository.dart';

class FetchPastAppointmentsUseCase {
  final AppointmentsRepository appointmentsRepository;
  
  FetchPastAppointmentsUseCase(this.appointmentsRepository);
  Future<PastAppointmentsModel> call({required int patientId}) async {
    return appointmentsRepository.fetchPastAppointments(patientId);
  }
}