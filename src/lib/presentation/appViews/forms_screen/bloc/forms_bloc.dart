import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:src/config/config.dart';
import 'package:src/data/model/forms_model.dart';
import 'package:src/data/model/notifications_model.dart';
import 'package:src/domain/usecase/form/fetch_forms_use_case.dart';
import 'package:src/domain/usecase/form/get_token_use_case.dart';
import 'package:src/shared/shared_preferences.dart';

part 'forms_event.dart';
part 'forms_state.dart';

class FormsBloc extends Bloc<FormsEvent, FormsState> {
  final FetchFormsUseCase fetchFormsUseCase;
  final GetTokenUseCase getTokenUseCase;

  FormsBloc(this.fetchFormsUseCase, this.getTokenUseCase)
      : super(FormsInitial()) {
    on<FormsGetPatientId>(_getPatientId);
    on<FetchForms>(_handleFetchForms);
    on<RequestFormToken>(_requestToken);
  }

  void _handleFetchForms(FetchForms event, Emitter<FormsState> emit) async {
    emit(FormsLoading());
    try {
      final patientName = await _getPatientName();
      final data = await fetchFormsUseCase(patientId: event.patientId);
      emit(FormsLoaded(data, patientName));
    } on DioException catch (e) {
      emit(FormsError(e.response!.statusCode));
    }
  }

  void _getPatientId(FormsGetPatientId event, Emitter<FormsState> emit) async {
    emit(FormsLoading());
    final patientId =
        await MySharedPreferences.instance.getIntValue(event.keyName);
    if (patientId != null) {
      emit(FormsPatientIdLoaded(patientId));
    } else {
      emit(FormsError(_mapFailureMessage()));
    }
  }

  void _requestToken(RequestFormToken event, Emitter<FormsState> emit) async {
    emit(FormsLoading());
    try {
      final token = await getTokenUseCase(
          collectionId: event.collectionId,
          patientId: event.patientId,
          userId: event.userId,
          isDoctor: event.isDoctor);
      final form = event.form;
      emit(FormTokenReceived(token, form));
    } on DioException catch (e) {
      emit(FormsError(e.response!.statusCode));
    }
  }

  Future<String> _getPatientName() async {
    final patientName =
        await MySharedPreferences.instance.getStringValue(USER_FIRSTNAME);
    final patientLastName =
        await MySharedPreferences.instance.getStringValue(USER_LASTNAME);
    
    final patientFullName = '$patientName $patientLastName';
    
    final patient_prefFirstName =
        await MySharedPreferences.instance.getStringValue(USER_PREF_FIRSTNAME);

    final patient_prefmiddleName =
        await MySharedPreferences.instance.getStringValue(USER_PREF_MIDDLENAME);

    final patient_prefLastName =
        await MySharedPreferences.instance.getStringValue(USER_PREF_LASTNAME);

    final patientPreferredFullName = '$patient_prefFirstName $patient_prefmiddleName $patient_prefLastName'.trim();
    final cleanedPatientPreferredFullName = patientPreferredFullName.replaceAll(RegExp(r'\s+'), ' ');

    if(cleanedPatientPreferredFullName.isNotEmpty){
      return cleanedPatientPreferredFullName;
    } else {
      return patientFullName;
    }
  }

  String _mapFailureMessage() {
    return 'Unexpected error';
  }
}
