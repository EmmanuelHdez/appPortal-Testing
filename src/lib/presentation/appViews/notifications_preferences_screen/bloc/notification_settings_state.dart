part of 'notification_settings_bloc.dart';

class NotificationSettingsState extends Equatable {
  const NotificationSettingsState();
  @override
  List<Object?> get props => [];
}

class NotificationSettingsInitial extends NotificationSettingsState {}

class NotificationSettingsLoading extends NotificationSettingsState {}

class NotificationSettingsLoaded extends NotificationSettingsState {
  final NotificationSettingsModel notificationSettingsModel;
  final String patientName;
  const NotificationSettingsLoaded(
      this.notificationSettingsModel, this.patientName);

  @override
  List<Object> get props => [notificationSettingsModel, patientName];
}

class NotificationSettingsSubmitted extends NotificationSettingsState {
  final NotificationResponseModel notificationResponseModel;
  const NotificationSettingsSubmitted(
      this.notificationResponseModel);

  @override
  List<Object> get props => [notificationResponseModel];
}

class NotificationsScreenValidated extends NotificationSettingsState {
  final dynamic response;
  const NotificationsScreenValidated(this.response);

  @override
  List<Object> get props => [response];
}

class NotificationSettingsError extends NotificationSettingsState {
  final dynamic message;

  const NotificationSettingsError(this.message);
  @override
  List<Object?> get props => [message];
}
