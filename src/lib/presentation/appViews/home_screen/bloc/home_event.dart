part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object> get props => [];
}
class HomeGetValues extends HomeEvent {
  final String keyName;

  const HomeGetValues(this.keyName);
    @override
  List<Object> get props => [keyName];
}

class HomeFetchNotifications extends HomeEvent {
  final int patientId;

  const HomeFetchNotifications(this.patientId);
    @override
  List<Object> get props => [patientId];
}
