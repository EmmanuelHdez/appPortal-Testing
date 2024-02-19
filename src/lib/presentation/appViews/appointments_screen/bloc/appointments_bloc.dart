import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:src/config/config.dart';
import 'package:src/data/model/appointment_info_model.dart';
import 'package:src/data/model/appointments_model.dart';
import 'package:src/data/model/past_appointments_model.dart';
import 'package:src/domain/usecase/appointments/fetch_future_appointments_use_case.dart';
import 'package:src/domain/usecase/appointments/fetch_past_appointments_use_case.dart';
import 'package:src/domain/usecase/appointments/fetch_appointment_info_use_case.dart';
import 'package:src/shared/shared_preferences.dart';

part 'appointments_event.dart';
part 'appointments_state.dart';

class AppointmentsBloc extends Bloc<AppointmentsEvent, AppointmentsState> {
  final FetchFutureAppointmentsUseCase fetchFutureAppointmentsUseCase;
  final FetchPastAppointmentsUseCase fetchPastAppointmentsUseCase;
  final FetchAppointmentInfoUseCase fetchAppointmentInfoUseCase;

  AppointmentsBloc(this.fetchFutureAppointmentsUseCase, this.fetchPastAppointmentsUseCase, this.fetchAppointmentInfoUseCase) : super(AppointmentsInitial()) {
    on<AppointmentsGetPatientId>(_getPatientId);
    on<AppointmentsGetAppointmentId>(_getAppointmentId);
    on<FetchFutureAppointments>(_handlFetchAppointments);
    on<FetchAppointmentInfo>(_handlFetchAppointmentInfo);
  }

  void _handlFetchAppointments(FetchFutureAppointments event, Emitter<AppointmentsState> emit) async {
    emit(AppointmentsLoading());
    try {
      final patientName = await _getPatientName();
      final data = await fetchFutureAppointmentsUseCase(patientId: event.patientId);
      final dataPastAppointments = await fetchPastAppointmentsUseCase(patientId: event.patientId);
      emit(AllAppointmentsLoaded(data, dataPastAppointments, patientName,));
    } on DioException catch (e) {
      emit(AppointmentsError(e.response!.statusCode));
    }
  }

  void _handlFetchAppointmentInfo(FetchAppointmentInfo event, Emitter<AppointmentsState> emit) async {
    emit(AppointmentsLoading());
    try {
      final fetchFutureAppointments = await fetchFutureAppointmentsUseCase(patientId: event.patientId);
      final appointmentData = await fetchAppointmentInfoUseCase(appointmentId: event.appointmentId);
      emit(AppointmentInfoLoaded(appointmentData, fetchFutureAppointments));
    } on DioException catch (e) {
      emit(AppointmentsError(e.response!.statusCode));
    }
  }

  void _getPatientId(AppointmentsGetPatientId event, Emitter<AppointmentsState> emit) async {
    emit(AppointmentsLoading());
    final patientId =
        await MySharedPreferences.instance.getIntValue(event.keyName);
    if (patientId != null) {
      emit(AppointmentsPatientIdLoaded(patientId));
    } else {
      emit(AppointmentsError(_mapFailureMessage()));
    }
  }

  void _getAppointmentId(AppointmentsGetAppointmentId event, Emitter<AppointmentsState> emit) async {
    emit(AppointmentsLoading());
    final appointmentId =
        await MySharedPreferences.instance.getIntValue(event.keyName);
    if (appointmentId != null) {
      emit(AppointmentsAppointmentIdLoaded(appointmentId));
    } else {
      emit(AppointmentsError(_mapFailureMessage()));
    }
  }

  Future<String> _getPatientName() async {
    final patientName =
        await MySharedPreferences.instance.getStringValue(USER_FIRSTNAME);
    final patientLastName =
        await MySharedPreferences.instance.getStringValue(USER_LASTNAME);

     final patientFullName = '$patientName $patientLastName';
    
    final patient_prefFirstName =
        await MySharedPreferences.instance.getStringValue(USER_PREF_FIRSTNAME);

    final patient_prefmiddleName =
        await MySharedPreferences.instance.getStringValue(USER_PREF_MIDDLENAME);

    final patient_prefLastName =
        await MySharedPreferences.instance.getStringValue(USER_PREF_LASTNAME);

    final patientPreferredFullName = '$patient_prefFirstName $patient_prefmiddleName $patient_prefLastName'.trim();
    final cleanedPatientPreferredFullName = patientPreferredFullName.replaceAll(RegExp(r'\s+'), ' ');

    if(cleanedPatientPreferredFullName.isNotEmpty){
      return cleanedPatientPreferredFullName;
    } else {
      return patientFullName;
    }
  }

  String _mapFailureMessage() {
    return 'Unexpected error';
  }
}

