part of 'pref_auth_methods_bloc.dart';

abstract class PrefauthMethodsEvent extends Equatable {
  const PrefauthMethodsEvent();
  @override
  List<Object> get props => [];
}

class FetchPrefAuthMethods extends PrefauthMethodsEvent {
  const FetchPrefAuthMethods();
  @override
  List<Object> get props => [];
}

class UpdatePrefAuthMethods extends PrefauthMethodsEvent {
  final dynamic putBody;
  const UpdatePrefAuthMethods(this.putBody);
  @override
  List<Object> get props => [putBody];
}