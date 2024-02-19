part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  final dynamic message;

  const HomeError(this.message);
  @override
  List<Object?> get props => [message];
}

class HomeValuesLoaded extends HomeState {
  final int patientId;
  const HomeValuesLoaded(this.patientId);

  @override
  List<Object> get props => [patientId];
}

class HomeNotificationsLoaded extends HomeState {
  final String patientName;
  final List<NotificationsModel> notificationsModel;
  const HomeNotificationsLoaded(this.notificationsModel, this.patientName);

  @override
  List<Object> get props => [notificationsModel];
}
