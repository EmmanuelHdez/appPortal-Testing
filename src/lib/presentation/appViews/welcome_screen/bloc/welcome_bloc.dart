import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:src/data/model/token_b2c_model.dart';
import 'package:src/domain/usecase/notes/update_seenAt_by_patient.dart';
import 'package:src/data/model/user_model.dart';
import 'package:equatable/equatable.dart';
part 'welcome_event.dart';
part 'welcome_state.dart';

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  final UpdateSeenAtByPatientUseCase updateSeenAtByPatientUseCase;

  WelcomeBloc(this.updateSeenAtByPatientUseCase)
      : super(WelcomeLoginInitial()) {
    on<UpdateSeenAtField>((event, emit) async {
      emit(WelcomeLoading());
      final user = event.user;
      try {
        final result =
            await updateSeenAtByPatientUseCase(patientId: event.patientId);
        emit(SeenAtFieldUpdated(result, user));
      } on DioException catch (e) {
        emit(WelcomeError(e.response!.statusCode));
      }
    });
  }
}

