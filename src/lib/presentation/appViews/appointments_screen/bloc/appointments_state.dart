part of 'appointments_bloc.dart';

class AppointmentsState extends Equatable {
  const AppointmentsState();
  @override
  List<Object?> get props => [];
}

class AppointmentsInitial extends AppointmentsState {}

class AppointmentsLoading extends AppointmentsState {}

class AllAppointmentsLoaded extends AppointmentsState {
  final AppointmentsModel appointmentsModel;
  final PastAppointmentsModel pastAppointmentsModel;
  final String patientName;
  const AllAppointmentsLoaded(this.appointmentsModel, this.pastAppointmentsModel, this.patientName);

  @override
  List<Object> get props => [appointmentsModel, pastAppointmentsModel, patientName];
}

class AppointmentInfoLoaded extends AppointmentsState {
  final AppointmentInfoModel appointmentInfoModel;
  final AppointmentsModel futureAppointments;
  const AppointmentInfoLoaded(this.appointmentInfoModel, this.futureAppointments);

  @override
  List<Object> get props => [appointmentInfoModel];
}

class AppointmentsPatientIdLoaded extends AppointmentsState {
  final int patientId;
  const AppointmentsPatientIdLoaded(this.patientId);

  @override
  List<Object> get props => [patientId];
}

class AppointmentsAppointmentIdLoaded extends AppointmentsState {
  final int appointmentId;
  const AppointmentsAppointmentIdLoaded(this.appointmentId);

  @override
  List<Object> get props => [appointmentId];
}

class AppointmentsError extends AppointmentsState {
  final dynamic message;

  const AppointmentsError(this.message);
  @override
  List<Object?> get props => [message];
}