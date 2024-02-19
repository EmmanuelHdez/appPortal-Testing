part of 'welcome_bloc.dart';

class WelcomeState extends Equatable {
  const WelcomeState({
    this.email = '',
    this.password = '',
  });

  final String email;
  final String password;

  WelcomeState copyWith({String? email, String? password}) {
    return WelcomeState(
        email: email ?? this.email, password: password ?? this.password);
  }

  @override
  List<Object?> get props => [email, password];
}

class WelcomeLoginInitial extends WelcomeState {}

class WelcomeLoading extends WelcomeState {}

class WelcomeLoaded extends WelcomeState {
  final UserModel user;
  const WelcomeLoaded(this.user);
  @override
  List<Object?> get props => [user];
}

class SeenAtFieldUpdated extends WelcomeState {
  final dynamic result;
  final TokenB2cModel user;
  const SeenAtFieldUpdated(this.result, this.user);

  @override
  List<Object> get props => [result, user];
}

class WelcomeError extends WelcomeState {
  final dynamic message;
  const WelcomeError(this.message);
  @override
  List<Object?> get props => [message];
}
