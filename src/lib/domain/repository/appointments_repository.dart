import 'package:dio/dio.dart';
import 'package:src/data/model/appointments_model.dart';
import 'package:src/data/model/appointment_info_model.dart';
import 'package:src/data/model/past_appointments_model.dart';
import 'package:src/errors/dioException.dart';
import 'package:src/infrastructure/service/appointments_service.dart';

abstract class AppointmentsRepository {
  Future<AppointmentsModel> fetchFutureAppointments(int patientId);
  Future<PastAppointmentsModel> fetchPastAppointments(int patientId);
  Future<AppointmentInfoModel> fetchAppointmentInfo(int appointmentId);
}

class AppointmentsRepositoryImpl extends AppointmentsRepository {
  final AppointmentsService appointmentsService;

  AppointmentsRepositoryImpl(this.appointmentsService);

  @override
  Future<AppointmentsModel> fetchFutureAppointments(int patientId) async {
    try {
      final request = await appointmentsService.fetchFutureAppointments(patientId);
      return request;
    } on DioException catch (e) {
      throw resposeDioException(e, '');
    }
  }

  @override
  Future<PastAppointmentsModel> fetchPastAppointments(int patientId) async {
    try {
      final request = await appointmentsService.fetchPastAppointments(patientId);
      return request;
    } on DioException catch (e) {
      throw resposeDioException(e, '');
    }
  }

  @override
  Future<AppointmentInfoModel> fetchAppointmentInfo(int appointmentId) async {
    try {
      final request = await appointmentsService.fetchAppointmentInfo(appointmentId);
      return request;
    } on DioException catch (e) {
      throw resposeDioException(e, '');
    }
  }
}