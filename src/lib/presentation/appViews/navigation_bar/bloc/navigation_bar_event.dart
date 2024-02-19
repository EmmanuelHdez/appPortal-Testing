part of 'navigation_bar_bloc.dart';

abstract class NavigationBarEvent extends Equatable {
  const NavigationBarEvent();
  @override
  List<Object> get props => [];
}

class FetchNotifications extends NavigationBarEvent {
  const FetchNotifications();
  @override
  List<Object> get props => [];
}

class IncrementEvent extends NavigationBarEvent {
  final int notes;
  final int appointments;
  final int forms;
  final int notifications;

 const IncrementEvent(this.notes, this.appointments, this.forms, this.notifications);
  @override
  List<Object> get props => [notes, appointments, forms, notifications];  
}

class DecrementEvent extends NavigationBarEvent {
  final int notes;
  final int appointments;
  final int forms;
  final int notifications;

 const DecrementEvent(this.notes, this.appointments, this.forms, this.notifications);
  @override
  List<Object> get props => [notes, appointments, forms, notifications];  
}
class UpdateCounters extends NavigationBarEvent {
  final int notes;
  final int appointments;
  final int forms;
  final int notifications;

 const UpdateCounters(this.notes, this.appointments, this.forms, this.notifications);
  @override
  List<Object> get props => [notes, appointments, forms, notifications];
}

