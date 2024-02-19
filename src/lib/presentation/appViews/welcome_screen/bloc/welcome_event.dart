part of 'welcome_bloc.dart';

abstract class WelcomeEvent extends Equatable {
  const WelcomeEvent();
  @override
  List<Object> get props => [];
}

class WelcomeLoginSubmitted extends WelcomeEvent {
  final String email;
  const WelcomeLoginSubmitted(this.email);
}

class DoLogIn extends WelcomeEvent {
  final String email;
  const DoLogIn(this.email);
  @override
  List<Object> get props => [email];
}

class UpdateSeenAtField extends WelcomeEvent {
  final int patientId;
  final TokenB2cModel user;
  const UpdateSeenAtField(this.patientId, this.user);
  @override
  List<Object> get props => [patientId, user];
}
