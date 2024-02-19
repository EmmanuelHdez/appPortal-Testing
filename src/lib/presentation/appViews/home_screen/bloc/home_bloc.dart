// ignore_for_file: unnecessary_null_comparison
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:src/config/config.dart';
import 'package:src/data/model/notifications_model.dart';
import 'package:src/domain/usecase/home/notifications_use_case.dart';
import 'package:src/shared/shared_preferences.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final NotificationsUseCase notificationsUseCase;

  HomeBloc(this.notificationsUseCase) : super(HomeInitial()) {
    on<HomeGetValues>(_handleHomeGetValues);
    on<HomeFetchNotifications>(_handleHomeFetchNotifications);
  }

  void _handleHomeGetValues(
      HomeGetValues event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    final value = await getValue(event.keyName);
    if (value != null) {
      emit(HomeValuesLoaded(value));
    } else {
      emit(HomeError(_mapFailureMessage()));
    }
  }

  void _handleHomeFetchNotifications(
      HomeFetchNotifications event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final patientName = await _getPatientName();
      final notifications =
          await notificationsUseCase(patientId: event.patientId);
      emit(HomeNotificationsLoaded(notifications, patientName));
    } on DioException catch (e) {
      emit(HomeError(e.response!.statusCode));
    }
  }

  String _mapFailureMessage() {
    return 'Unexpected error';
  }

  Future<int> getValue(String keyName) {
    var value = MySharedPreferences.instance.getIntValue(keyName);
    return value;
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
}
