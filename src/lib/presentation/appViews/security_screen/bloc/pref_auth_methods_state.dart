part of 'pref_auth_methods_bloc.dart';

class PrefAuthMethodsState extends Equatable {
  final String prefAuthMethodsPutBody;
  const PrefAuthMethodsState({
    this.prefAuthMethodsPutBody = '',
  });

  PrefAuthMethodsState copyWith({String? prefAuthMethodsPutBody}) {
    return PrefAuthMethodsState(prefAuthMethodsPutBody: prefAuthMethodsPutBody ?? this.prefAuthMethodsPutBody);
  }

  @override
  List<Object?> get props => [prefAuthMethodsPutBody];
}

class PrefauthMethodsInitial extends PrefAuthMethodsState {}

class PrefAuthMethodsLoading extends PrefAuthMethodsState {}

class PrefauthMethodsLoaded extends PrefAuthMethodsState {
  final PrefauthMethodsModel prefauthMethodsModel;
  const PrefauthMethodsLoaded(this.prefauthMethodsModel);

  @override
  List<Object> get props => [prefauthMethodsModel];
}

class PrefAuthMethodsError extends PrefAuthMethodsState {
  final dynamic message;

  const PrefAuthMethodsError(this.message);
  @override
  List<Object?> get props => [message];
}

class PrefAuthMethodsUpdated extends PrefAuthMethodsState {
  final PutPrefauthMethodsResModel result;
  const PrefAuthMethodsUpdated(this.result);

  @override
  List<Object> get props => [result];
}
