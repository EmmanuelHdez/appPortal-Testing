import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:src/config/config.dart';
import 'package:src/data/model/pref_auth_methods_model.dart';
import 'package:src/data/model/put_pref_auth_methods_res_model.dart';
import 'package:src/domain/usecase/pref_auth_methods/fetch_pref_auth_methods_use_case.dart';
import 'package:src/domain/usecase/pref_auth_methods/update_pref_auth_methods_use_case.dart';
import 'package:src/shared/shared_preferences.dart';

part 'pref_auth_methods_event.dart';
part 'pref_auth_methods_state.dart';

class PrefAuthMethodsBloc extends Bloc<PrefauthMethodsEvent, PrefAuthMethodsState> {
  final FetchPrefAuthMethodsUseCase fetchPrefAuthMethodsUseCase;
  final UpdatePrefAuthMethodsUseCase updatePrefAuthMethodsUseCase;

  PrefAuthMethodsBloc(this.fetchPrefAuthMethodsUseCase, this.updatePrefAuthMethodsUseCase)
      : super(PrefauthMethodsInitial()) {
    on<FetchPrefAuthMethods>(_handlFetchPrefAuthMethods);
    on<UpdatePrefAuthMethods>(_updatePrefAuthMethods);
  }

  void _handlFetchPrefAuthMethods(
      FetchPrefAuthMethods event, Emitter<PrefAuthMethodsState> emit) async {
    emit(PrefAuthMethodsLoading());
    try {
      final patientId =
          await MySharedPreferences.instance.getIntValue(PATIENT_ID);
      final data = await fetchPrefAuthMethodsUseCase(patientId: patientId);
      emit(PrefauthMethodsLoaded(
        data,
      ));
    } on DioException catch (e) {
      emit(PrefAuthMethodsError(e.response!.statusCode));
    }
  }

  void _updatePrefAuthMethods(UpdatePrefAuthMethods event, Emitter<PrefAuthMethodsState> emit) async {
    emit(PrefAuthMethodsLoading());
    try {
      final patientId =
          await MySharedPreferences.instance.getIntValue(PATIENT_ID);
      final updateRes = await updatePrefAuthMethodsUseCase(
        patientId: patientId,
        putBody: event.putBody,
      );
      emit(PrefAuthMethodsUpdated(updateRes));
    } on DioException catch (e) {
      emit(PrefAuthMethodsError(e.response!.statusCode));
    }
  }

  String _mapFailureMessage() {
    return 'Unexpected error';
  }

}
