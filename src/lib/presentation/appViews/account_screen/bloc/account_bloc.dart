import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:src/config/config.dart';
import 'package:src/data/model/account_model.dart';
import 'package:src/data/model/upload_photo.model.dart';
import 'package:src/domain/usecase/account_use_case.dart';
import 'package:src/domain/usecase/files/upload_photo_use_case.dart';
import 'package:src/shared/shared_preferences.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountUseCase accountUseCase;
  final UploadPhotoUseCase uploadPhotoUseCase;

  AccountBloc(this.accountUseCase, this.uploadPhotoUseCase)
      : super(AccountInitial()) {
    on<FetchPatient>(_handlFetchPatients);
    on<UploadPhoto>(_savePhoto);
  }

  void _handlFetchPatients(
      FetchPatient event, Emitter<AccountState> emit) async {
    emit(AccountLoading());
    try {
      final patientId =
          await MySharedPreferences.instance.getIntValue(PATIENT_ID);
      final data = await accountUseCase(patientId: patientId);
      emit(AccountLoaded(data));
    } on DioException catch (e) {
      emit(AccountError(e.response!.statusCode));
    }
  }

  void _savePhoto(UploadPhoto event, Emitter<AccountState> emit) async {
    emit(AccountLoading());
    try {
      final data = await uploadPhotoUseCase(
          userId: event.userId,
          filePath: event.filePath,
          fileName: event.fileName);
      emit(UploadPhotoLoaded(data));
    } on DioException catch (e) {
      emit(UploadPhotoError(e.response!.statusCode));
    }
  }

  Future<int> getValue(String keyName) {
    var value = MySharedPreferences.instance.getIntValue(keyName);
    return value;
  }
}
