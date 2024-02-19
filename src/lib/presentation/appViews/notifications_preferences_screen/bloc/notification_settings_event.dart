part of 'notification_settings_bloc.dart';

abstract class NotificationSettingsEvent extends Equatable {
  const NotificationSettingsEvent();
  @override
  List<Object> get props => [];
}

class GetNotificationSettings extends NotificationSettingsEvent {
  const GetNotificationSettings();
  @override
  List<Object> get props => [];
}

class SubmitNotificationSettings extends NotificationSettingsEvent {
  final String notificationSetting;
  const SubmitNotificationSettings(
    this.notificationSetting,
  );
  @override
  List<Object> get props => [notificationSetting];
}

class ValidateNotificationSettingsScreen extends NotificationSettingsEvent {
  final int showSettingsValue;
  const ValidateNotificationSettingsScreen(this.showSettingsValue);
    @override
  List<Object> get props => [showSettingsValue];
}
