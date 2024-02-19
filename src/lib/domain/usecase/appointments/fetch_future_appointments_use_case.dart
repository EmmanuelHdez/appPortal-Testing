import 'package:src/data/model/appointments_model.dart';
import 'package:src/domain/repository/appointments_repository.dart';

class FetchFutureAppointmentsUseCase {
  final AppointmentsRepository appointmentsRepository;
  
  FetchFutureAppointmentsUseCase(this.appointmentsRepository);
  Future<AppointmentsModel> call({required int patientId}) async {
    return appointmentsRepository.fetchFutureAppointments(patientId);
  }
}