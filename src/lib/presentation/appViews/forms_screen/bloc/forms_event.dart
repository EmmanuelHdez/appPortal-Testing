part of 'forms_bloc.dart';

abstract class FormsEvent extends Equatable {
  const FormsEvent();
  @override
  List<Object> get props => [];
}

class FormsGetPatientId extends FormsEvent {
  final String keyName;

  const FormsGetPatientId(this.keyName);
  @override
  List<Object> get props => [keyName];
}

class FetchForms extends FormsEvent {
  final int patientId;
  const FetchForms(this.patientId);
  @override
  List<Object> get props => [patientId];
}

class RequestFormToken extends FormsEvent {
  final int collectionId;
  final int patientId;
  final int userId;
  final bool isDoctor;
   final Map<String, dynamic> form;
  const RequestFormToken(this.collectionId, this.patientId, this.userId, this.isDoctor, this.form);
 @override
  List<Object> get props => [collectionId, patientId, userId, isDoctor, form];
}