import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:src/config/config.dart';
import 'package:src/data/model/create_note_model.dart';
import 'package:src/data/model/notes_model.dart';
import 'package:src/data/model/notifications_model.dart';
import 'package:src/domain/usecase/form/get_token_use_case.dart';
import 'package:src/domain/usecase/notes/create_note_use_case.dart';
import 'package:src/domain/usecase/notes/fetch_unread_notes_use_case.dart';
import 'package:src/domain/usecase/notes/mark_as_seen_use_case.dart';
import 'package:src/shared/shared_preferences.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final FetchUnreadNotesUseCase fetchUnreadNotesUseCase;
  final CreateNoteUseCase createNoteUseCase;
  final MarkAsSeenUseCase markAsSeenUseCase;
  final GetTokenUseCase getTokenUseCase;

  NotesBloc(this.fetchUnreadNotesUseCase, this.createNoteUseCase,
      this.markAsSeenUseCase, this.getTokenUseCase)
      : super(NotesInitial()) {
    on<FetchUnreadNotes>(_handlFetchUnreadNotes);
    on<CreateNote>(_createNote);
    on<GetNoteText>(_getNoteText);
    on<MarkNoteAsSeen>(_markNoteAsSeen);
    on<RequestFormToken>(_requestToken);
  }

  void _getNoteText(GetNoteText event, Emitter<NotesState> emit) {
    emit(const NotesState().copyWith(noteBody: event.noteBody));
  }

  void _handlFetchUnreadNotes(
      FetchUnreadNotes event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    try {
      final patientName = await _getPatientName();
      final patientId =
          await MySharedPreferences.instance.getIntValue(PATIENT_ID);
      final data = await fetchUnreadNotesUseCase(patientId: patientId);
      emit(UnreadNotesLoaded(
        data,
        patientName,
      ));
    } on DioException catch (e) {
      emit(NotesError(e.response!.statusCode));
    }
  }

  void _createNote(CreateNote event, Emitter<NotesState> emit) async {
    emit(NotesDetailsLoading());
    try {
      final patientId =
          await MySharedPreferences.instance.getIntValue(PATIENT_ID);
      final note = await createNoteUseCase(
        patientId: patientId,
        baseNoteId: event.baseNoteId,
        noteBody: event.noteBody,
      );
      emit(NoteCreated(note));
    } on DioException catch (e) {
      emit(NotesError(e.response!.statusCode));
    }
  }

  void _markNoteAsSeen(MarkNoteAsSeen event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    try {
      final result = await markAsSeenUseCase(noteId: event.noteId);
      emit(NoteMarkedAsSeen(result, event.noteData));
    } on DioException catch (e) {
      emit(NotesError(e.response!.statusCode));
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

    final patientPreferredFullName =
        '$patient_prefFirstName $patient_prefmiddleName $patient_prefLastName'
            .trim();
    final cleanedPatientPreferredFullName =
        patientPreferredFullName.replaceAll(RegExp(r'\s+'), ' ');

    if (cleanedPatientPreferredFullName.isNotEmpty) {
      return cleanedPatientPreferredFullName;
    } else {
      return patientFullName;
    }
  }
  void _requestToken(RequestFormToken event, Emitter<NotesState> emit) async {
    emit(NotesDetailsLoading());
    try {
      final token = await getTokenUseCase(
          collectionId: event.collectionId,
          patientId: event.patientId,
          userId: event.userId,
          isDoctor: event.isDoctor);
      final form = event.form;
      emit(FormTokenReceived(token, form));
    } on DioException catch (e) {
      emit(NotesError(e.response!.statusCode));
    }
  }
}
