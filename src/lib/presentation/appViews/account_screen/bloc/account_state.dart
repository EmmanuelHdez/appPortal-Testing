part of 'account_bloc.dart';

class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object?> get props => [];
}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class UploadPhotoLoading extends AccountState {}
class AccountLoaded extends AccountState {
  final AccountModel accountModel;
  const AccountLoaded(this.accountModel);

  @override
  List<Object> get props => [accountModel];
}

class AccountError extends AccountState {
  final dynamic message;

  const AccountError(this.message);
  @override
  List<Object?> get props => [message];
}

class UploadPhotoLoaded extends AccountState {
  final UploadPhotoModel uploadPhotoModel;

  const UploadPhotoLoaded(this.uploadPhotoModel);
    @override
  List<Object?> get props => [uploadPhotoModel];
}

class UploadPhotoError extends AccountState {
  final dynamic message;

  const UploadPhotoError(this.message);
  @override
  List<Object?> get props => [message];
}