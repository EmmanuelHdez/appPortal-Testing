import 'package:src/data/model/appointment_info_model.dart';
import 'package:src/domain/repository/appointments_repository.dart';

class FetchAppointmentInfoUseCase {
  final AppointmentsRepository appointmentsRepository;
  
  FetchAppointmentInfoUseCase(this.appointmentsRepository);
  Future<AppointmentInfoModel> call({required int appointmentId}) async {
    return appointmentsRepository.fetchAppointmentInfo(appointmentId);
  }
}