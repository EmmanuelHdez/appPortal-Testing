part of 'forms_bloc.dart';

class FormsState extends Equatable {
  const FormsState();
  @override
  List<Object?> get props => [];
}

class FormsInitial extends FormsState {}

class FormsLoading extends FormsState {}

class FormsLoaded extends FormsState {
  final FormsModel formsModel;
  final String patientName;
  const FormsLoaded(this.formsModel, this.patientName);

  @override
  List<Object> get props => [formsModel, patientName];
}

class FormsPatientIdLoaded extends FormsState {
  final int patientId;
  const FormsPatientIdLoaded(this.patientId);

  @override
  List<Object> get props => [patientId];
}

class FormTokenReceived extends FormsState {
  final Map<String, dynamic> form;
  final FormCollectionsTokenModel result;

  const FormTokenReceived(this.result, this.form);

  @override
  List<Object> get props => [result, form];
}

class FormsError extends FormsState {
  final dynamic message;

  const FormsError(this.message);
  @override
  List<Object?> get props => [message];
}
