import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:src/config/config.dart';
import 'package:src/data/model/notifications_model.dart';
import 'package:src/domain/usecase/home/notifications_use_case.dart';
import 'package:src/shared/shared_preferences.dart';

part 'navigation_bar_event.dart';
part 'navigation_bar_state.dart';

class NavigationBarBloc extends Bloc<NavigationBarEvent, NavigationBarState> {
  final NotificationsUseCase notificationsUseCase;

  NavigationBarBloc(this.notificationsUseCase) : super(NavigationBarInitial()) {
    on<FetchNotifications>(_handleHomeFetchNotifications);
    on<IncrementEvent>((event, emit) {
      emit(
        NavigationBarState(
          notesCounter: state.notesCounter! + event.notes, 
          formsCounter: state.formsCounter! + event.forms, 
          appointmentsCounter: state.appointmentsCounter! + event.appointments, 
          notificationsCounter: state.notificationsCounter! + event.notifications,
          patientName: state.patientName
          ));
    });
    on<DecrementEvent>((event, emit) {
      emit(
        NavigationBarState(
          notesCounter: state.notesCounter! - event.notes, 
          formsCounter: state.formsCounter! - event.forms, 
          appointmentsCounter: state.appointmentsCounter! - event.appointments, 
          notificationsCounter: state.notificationsCounter! - event.notifications,
          patientName: state.patientName
          ));
    });
    on<UpdateCounters>((event, emit) {
      emit(
        NavigationBarState(
          notesCounter: event.notes, 
          formsCounter: event.forms, 
          appointmentsCounter: event.appointments, 
          notificationsCounter: event.notifications,
          patientName: state.patientName
          ));
    });
  }

  void _handleHomeFetchNotifications(
      FetchNotifications event, Emitter<NavigationBarState> emit) async {
    emit(NavigationBarLoading());
    try {
      final patientName = await _getPatientName();
      final patientId =
          await MySharedPreferences.instance.getIntValue(PATIENT_ID);
      final notifications = await notificationsUseCase(patientId: patientId);
      final notesCounter = _findModule(notifications, 'notes')!.count;
      final formsCounter = _findModule(notifications, 'formCollections')!.count;
      final appointmentsCounter =
          _findModule(notifications, 'appointments')!.count;
      final notificationsCounter =
          _findModule(notifications, 'totalElements')!.count;
      emit(NavigationBarNotificationsLoaded(
          notifications,
          patientName,
          notesCounter,
          formsCounter,
          appointmentsCounter,
          notificationsCounter));
    } on DioException catch (e) {
      emit(NavigationBarError(e.response!.statusCode));
    }
  }

  _findModule(List<NotificationsModel> counters, String name) {
    final counter =
        counters.where((element) => element.component == name).firstOrNull;
    return counter;
  }

  Future<String> _getPatientName() async {
    final patientName =
        await MySharedPreferences.instance.getStringValue(USER_FIRSTNAME);
    final patientLastName =
        await MySharedPreferences.instance.getStringValue(USER_LASTNAME);
    return '$patientName $patientLastName';
  }
}
