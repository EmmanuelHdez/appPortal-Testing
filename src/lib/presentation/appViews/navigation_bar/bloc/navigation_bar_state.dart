part of 'navigation_bar_bloc.dart';

class NavigationBarState extends Equatable {
  final int? notesCounter;
  final int? formsCounter;
  final int? appointmentsCounter;
  final int? notificationsCounter;
  final String patientName;

  const NavigationBarState({
    this.notesCounter = 0,
    this.formsCounter = 0,
    this.appointmentsCounter = 0,
    this.notificationsCounter = 0,
    this.patientName = '',
  });

  NavigationBarState copyWith({
    int? notesCounter,
    int? formsCounter,
    int? appointmentsCounter,
    int? notificationsCounter,
    required String patientName,

  }) {
    return NavigationBarState(
      notesCounter: notesCounter,
      formsCounter: formsCounter,
      appointmentsCounter: appointmentsCounter,
      notificationsCounter: notificationsCounter,
      patientName: patientName,
    );
  }

  @override
  List<Object?> get props =>
      [notesCounter, formsCounter, appointmentsCounter, notificationsCounter, patientName];
}

class NavigationBarInitial extends NavigationBarState {}

class NavigationBarLoading extends NavigationBarState {}

class Refetched extends NavigationBarState {
  final bool refetched;
  const Refetched(this.refetched);
  @override
  List<Object> get props => [refetched];
}

class NavigationBarError extends NavigationBarState {
  final dynamic message;

  const NavigationBarError(this.message);
  @override
  List<Object?> get props => [message];
}

class NavigationBarNotificationsLoaded extends NavigationBarState {
  final String patientName;
  final List<NotificationsModel> notificationsModel;
  final notesCounter;
  final formsCounter;
  final appointmentsCounter;
  final notificationsCounter;
  const NavigationBarNotificationsLoaded(
      this.notificationsModel,
      this.patientName,
      this.notesCounter,
      this.formsCounter,
      this.appointmentsCounter,
      this.notificationsCounter
      );

  @override
  List<Object> get props => [notificationsModel, patientName];
}
