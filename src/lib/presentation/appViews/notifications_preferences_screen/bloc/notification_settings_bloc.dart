import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:src/config/config.dart';
import 'package:src/data/model/notifications_model.dart';
import 'package:src/domain/usecase/notifications/get_notification_settings.dart';
import 'package:src/domain/usecase/notifications/save_notifications_settings.dart';
import 'package:src/domain/usecase/notifications/validate_notifications_screen.dart';
import 'package:src/shared/shared_preferences.dart';
import 'package:src/shared/user_preferences.dart';

part 'notification_settings_event.dart';
part 'notification_settings_state.dart';

class NotificationSettingsBloc
    extends Bloc<NotificationSettingsEvent, NotificationSettingsState> {
  final GetNotificationSettingsUseCase getNotificationSettingsUseCase;
  final SaveNotificationSettingsUseCase saveNotificationSettingsUseCase;
  final ValidateNotificationSettingsScreenUseCase
      validateNotificationsScreenUseCase;
  NotificationSettingsBloc(
      this.getNotificationSettingsUseCase,
      this.saveNotificationSettingsUseCase,
      this.validateNotificationsScreenUseCase)
      : super(NotificationSettingsInitial()) {
    on<GetNotificationSettings>(_handlGetNotificationSettings);
    on<SubmitNotificationSettings>(_saveNotificationSettings);
    on<ValidateNotificationSettingsScreen>(_validateNotificationScreen);
  }

  void _handlGetNotificationSettings(GetNotificationSettings event,
      Emitter<NotificationSettingsState> emit) async {
    emit(NotificationSettingsLoading());
    try {
      final patientName = await _getPatientName();
      final userId = await MySharedPreferences.instance.getIntValue(USER_ID);
      final data = await getNotificationSettingsUseCase(userId: userId);
      emit(NotificationSettingsLoaded(
        data,
        patientName,
      ));
    } on DioException catch (e) {
      emit(NotificationSettingsError(e.response!.statusCode));
    }
  }

  void _saveNotificationSettings(SubmitNotificationSettings event,
      Emitter<NotificationSettingsState> emit) async {
    emit(NotificationSettingsLoading());
    try {
      final userId = await MySharedPreferences.instance.getIntValue(USER_ID);
      final data = await saveNotificationSettingsUseCase(
          userId: userId, notificationSetting: event.notificationSetting);
      emit(NotificationSettingsSubmitted(data));
    } on DioException catch (e) {
      emit(NotificationSettingsError(e.response!.statusCode));
    }
  }

  void _validateNotificationScreen(ValidateNotificationSettingsScreen event,
      Emitter<NotificationSettingsState> emit) async {
    try {
      final UserPreferences userInfo = UserPreferences();
      final data = await validateNotificationsScreenUseCase(
          showSettingsValue: event.showSettingsValue);
    if (data['success'] == true) {
     userInfo.saveShowSettingsValue(false);
    }
    } on DioException catch (e) {
      emit(NotificationSettingsError(e.response!.statusCode));
    }
  }

  Future<String> _getPatientName() async {
    final patientName =
        await MySharedPreferences.instance.getStringValue(USER_FIRSTNAME);
    final patientLastName =
        await MySharedPreferences.instance.getStringValue(USER_LASTNAME);
    return '$patientName $patientLastName';
  }
}
