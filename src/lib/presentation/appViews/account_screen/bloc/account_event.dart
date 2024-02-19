part of 'account_bloc.dart';
abstract class AccountEvent extends Equatable {
  const AccountEvent();
  @override
  List<Object> get props => [];
}
class GetPatientId extends AccountEvent {
  final String keyName;

  const GetPatientId(this.keyName);
  @override
  List<Object> get props => [keyName];
}

class FetchPatient extends AccountEvent {
  const FetchPatient();
  @override
  List<Object> get props => [];
}

class UploadPhoto extends AccountEvent {
  final int userId;
  final String fileName;
  final String filePath;

  const UploadPhoto(this.userId, this.fileName, this.filePath);
  @override
  List<Object> get props => [userId, fileName, filePath];
}

class SavedFile extends AccountEvent {
  const SavedFile();
}
