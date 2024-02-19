part of 'appointments_bloc.dart';

abstract class AppointmentsEvent extends Equatable {
    const AppointmentsEvent();
  @override
  List<Object> get props => [];
}

class AppointmentsGetPatientId extends AppointmentsEvent {
  final String keyName;

  const AppointmentsGetPatientId(this.keyName);
  @override
  List<Object> get props => [keyName];
}

class AppointmentsGetAppointmentId extends AppointmentsEvent {
  final String keyName;

  const AppointmentsGetAppointmentId(this.keyName);
  @override
  List<Object> get props => [keyName];
}

class FetchFutureAppointments extends AppointmentsEvent {
  final int patientId;
  const FetchFutureAppointments(this.patientId);
  @override
  List<Object> get props => [patientId];
}

class FetchAppointmentInfo extends AppointmentsEvent {
  final int appointmentId;
  final int patientId;
  const FetchAppointmentInfo(this.appointmentId, this.patientId);
  @override
  List<Object> get props => [appointmentId, patientId];
}
