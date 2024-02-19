import 'package:get_it/get_it.dart';
import 'package:socket_io_client/src/socket.dart';
import 'package:src/data/datasource/socket_datasource.dart';
import 'package:src/domain/repository/account_repository.dart';
import 'package:src/domain/repository/notes_repository.dart';
import 'package:src/domain/repository/appointments_repository.dart';
import 'package:src/domain/repository/forms_repository.dart';
import 'package:src/domain/repository/notifications_repository.dart';
import 'package:src/domain/repository/pref_auth_methods_repository.dart';
import 'package:src/domain/repository/socket_repository.dart';
import 'package:src/domain/repository/upload_files_repository.dart';
import 'package:src/domain/usecase/account_use_case.dart';
import 'package:src/domain/usecase/notes/create_note_use_case.dart';
import 'package:src/domain/usecase/notes/fetch_unread_notes_use_case.dart';
import 'package:src/domain/usecase/appointments/fetch_future_appointments_use_case.dart';
import 'package:src/domain/usecase/appointments/fetch_past_appointments_use_case.dart';
import 'package:src/domain/usecase/appointments/fetch_appointment_info_use_case.dart';
import 'package:src/domain/usecase/files/upload_photo_use_case.dart';
import 'package:src/domain/usecase/form/fetch_forms_use_case.dart';
import 'package:src/domain/usecase/form/get_token_use_case.dart';
import 'package:src/domain/usecase/notes/mark_as_seen_use_case.dart';
import 'package:src/domain/usecase/notes/update_seenAt_by_patient.dart';
import 'package:src/domain/usecase/notifications/get_notification_settings.dart';
import 'package:src/domain/usecase/notifications/save_notifications_settings.dart';
import 'package:src/domain/usecase/notifications/validate_notifications_screen.dart';
import 'package:src/domain/usecase/pref_auth_methods/fetch_pref_auth_methods_use_case.dart';
import 'package:src/domain/usecase/pref_auth_methods/update_pref_auth_methods_use_case.dart';
import 'package:src/domain/usecase/socket_use_case.dart';
import 'package:src/external/socket_config.dart';
import 'package:src/infrastructure/service/acount_service.dart';
import 'package:src/infrastructure/service/notes_service.dart';
import 'package:src/infrastructure/service/appointments_service.dart';
import 'package:src/infrastructure/service/forms_service.dart';
import 'package:src/infrastructure/service/notifications_service.dart';
import 'package:src/domain/usecase/home/notifications_use_case.dart';
import 'package:src/infrastructure/service/pref_auth_methods_service.dart';
import 'package:src/infrastructure/service/upload_files.dart';
import 'package:src/presentation/appViews/account_screen/bloc/account_bloc.dart';
import 'package:src/presentation/appViews/appointments_screen/bloc/appointments_bloc.dart';
import 'package:src/presentation/appViews/navigation_bar/bloc/navigation_bar_bloc.dart';
import 'package:src/presentation/appViews/notes_screen/bloc/notes_bloc.dart';
import 'package:src/presentation/appViews/forms_screen/bloc/forms_bloc.dart';
import 'package:src/presentation/appViews/home_screen/bloc/home_bloc.dart';
import 'package:src/presentation/appViews/notifications_preferences_screen/bloc/notification_settings_bloc.dart';
import 'package:src/presentation/appViews/security_screen/bloc/pref_auth_methods_bloc.dart';
import 'package:src/presentation/appViews/welcome_screen/bloc/welcome_bloc.dart';

// sl = service location
final sl = GetIt.instance;

Future<void> init() async {
  await initSocket();
  await initAuth();
  await initHome();
  await initAppointments();
  await initAccount();
  await initForms();
  await initNotes();
  await initPrefAuthMethods();
}

Future<void> initAuth() async {
  sl.registerFactory(() => WelcomeBloc(sl()));
}

Future<void> initHome() async {
  sl.registerFactory(() => HomeBloc(sl()));
  sl.registerFactory(() => NavigationBarBloc(sl()));
  sl.registerFactory(() => NotificationSettingsBloc(sl(), sl(), sl()));
  sl.registerLazySingleton(() => NotificationsUseCase(sl()));
  sl.registerLazySingleton(() => GetNotificationSettingsUseCase(sl()));
  sl.registerLazySingleton(() => SaveNotificationSettingsUseCase(sl()));
  sl.registerLazySingleton(
      () => ValidateNotificationSettingsScreenUseCase(sl()));
  sl.registerLazySingleton<NotificationsRepository>(
      () => NotificationsRepositoryImpl(sl()));
  sl.registerLazySingleton<NotificationsService>(
      () => NotificationsServiceImpl());
}

Future<void> initAppointments() async {
  sl.registerLazySingleton(() => FetchFutureAppointmentsUseCase(sl()));
  sl.registerLazySingleton(() => FetchPastAppointmentsUseCase(sl()));
  sl.registerLazySingleton(() => FetchAppointmentInfoUseCase(sl()));

  sl.registerFactory(() => AppointmentsBloc(
        sl<FetchFutureAppointmentsUseCase>(),
        sl<FetchPastAppointmentsUseCase>(),
        sl<FetchAppointmentInfoUseCase>(),
      ));

  sl.registerLazySingleton<AppointmentsRepository>(
      () => AppointmentsRepositoryImpl(sl()));
  sl.registerLazySingleton<AppointmentsService>(
      () => AppointmentsServiceImpl());
}

Future<void> initAccount() async {
  sl.registerFactory(() => AccountBloc(sl(), sl()));
  sl.registerLazySingleton(() => AccountUseCase(sl()));
  sl.registerLazySingleton<AccountRepository>(
      () => AccountRepositoryImpl(sl()));
  sl.registerLazySingleton<AccountService>(() => AccountServiceImpl());
  sl.registerLazySingleton(() => UploadPhotoUseCase(sl()));
  sl.registerLazySingleton<UploadFilesRepository>(
      () => UploadFilesRepositoryImpl(sl()));
  sl.registerLazySingleton<UploadFilesService>(() => UploadFilesServiceImpl());
}

Future<void> initForms() async {
  sl.registerFactory(() => FormsBloc(sl(), sl()));
  sl.registerLazySingleton(() => FetchFormsUseCase(sl()));
  sl.registerLazySingleton(() => GetTokenUseCase(sl()));
  sl.registerLazySingleton<FormsRepository>(() => FormsRepositoryImpl(sl()));
  sl.registerLazySingleton<FormsService>(() => FormsServiceImpl());
}

Future<void> initNotes() async {
  sl.registerFactory(() => NotesBloc(sl(), sl(), sl(), sl()));
  sl.registerLazySingleton(() => FetchUnreadNotesUseCase(sl()));
  sl.registerLazySingleton(() => MarkAsSeenUseCase(sl()));
  sl.registerLazySingleton(() => UpdateSeenAtByPatientUseCase(sl()));
  sl.registerLazySingleton(() => CreateNoteUseCase(sl()));
  sl.registerLazySingleton<NotesRepository>(() => NotesModelImpl(sl()));
  sl.registerLazySingleton<NotesService>(() => NotesServiceImpl());
}

Future<void> initPrefAuthMethods() async {
  sl.registerFactory(() => PrefAuthMethodsBloc(sl(), sl()));
  sl.registerLazySingleton(() => FetchPrefAuthMethodsUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePrefAuthMethodsUseCase(sl()));
  sl.registerLazySingleton<PrefauthMethodsRepository>(
      () => PrefauthMethodsModelImpl(sl()));
  sl.registerLazySingleton<PrefAuthMethodsService>(
      () => PrefAuthMethodsServiceImpl());
}

Future<dynamic> initSocket() async {
   Socket socket = await SocketConfig.initializeSocket();
  sl.registerLazySingleton(() => SocketDatasource(socket));
  sl.registerLazySingleton(() => SocketRepository(sl<SocketDatasource>()));
  sl.registerLazySingleton(() =>ConnectSocketUseCase(sl<SocketRepository>()));
  sl.registerLazySingleton(() =>OnEventUseCase(sl<SocketRepository>()));
  sl.registerLazySingleton(() =>EmitEventUseCase(sl<SocketRepository>()));
  sl.registerLazySingleton(() =>DisconnectSocketUseCase(sl<SocketRepository>()));
}
