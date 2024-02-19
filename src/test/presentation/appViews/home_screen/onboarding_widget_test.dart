import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:src/presentation/appViews/navigation_bar/bloc/navigation_bar_bloc.dart';
import 'package:src/data/model/notifications_model.dart';
import 'package:src/presentation/appViews/home_screen/onboarding_widget.dart';
import 'package:src/domain/repository/notifications_repository.dart';
import 'package:src/domain/usecase/home/notifications_use_case.dart';
import 'package:src/infrastructure/service/notifications_service.dart';

void main() {
  testWidgets('Render Onboarding successfully', (WidgetTester tester) async {
    dynamic jsonDataDoctor = {
      'title': 'Sr',
      'firstName': 'Gerardo',
      'lastName': 'Andrade',
    };

    dynamic jsonDataNotificationNotes = {
      "component": "notes",
      "count": 1,
    };

    NotificationsModel notificationModelNote =
        NotificationsModel.fromJson(jsonDataNotificationNotes);

    dynamic jsonDataNotificationNextAppointment = {
      "component": "nextAppointment",
      "count": 1,
      "doctor": jsonDataDoctor,
      "startTime": "2125-01-22 21:44:18",
    };

    NotificationsModel notificationModelNextAppointment =
        NotificationsModel.fromJson(jsonDataNotificationNextAppointment);

    List<NotificationsModel> notificationModeList = [
      notificationModelNote,
      notificationModelNextAppointment
    ];

    NotificationsService notificationsService = NotificationsServiceImpl();
    NotificationsRepository notificationsRepository =
        NotificationsRepositoryImpl(notificationsService);
    NotificationsUseCase notificationsUseCase =
        NotificationsUseCase(notificationsRepository);

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<NavigationBarBloc>(
                create: (context) => NavigationBarBloc(notificationsUseCase)),
          ],
          child: OnboardingWidget(
            notificationsModel: notificationModeList,
            patientName: 'John Doe',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
  });

  testWidgets('Onboarding of user with Appointnment',
      (WidgetTester tester) async {
    dynamic jsonDataDoctor = {
      'title': 'Sr',
      'firstName': 'Gerardo',
      'lastName': 'Andrade',
    };

    dynamic jsonDataNotificationNotes = {
      "component": "notes",
      "count": 1,
    };

    NotificationsModel notificationModelNote =
        NotificationsModel.fromJson(jsonDataNotificationNotes);

    dynamic jsonDataNotificationNextAppointment = {
      "component": "nextAppointment",
      "count": 1,
      "doctor": jsonDataDoctor,
      "startTime": "2125-01-22 21:44:18",
    };

    NotificationsModel notificationModelNextAppointment =
        NotificationsModel.fromJson(jsonDataNotificationNextAppointment);

    List<NotificationsModel> notificationModeList = [
      notificationModelNote,
      notificationModelNextAppointment
    ];

    NotificationsService notificationsService = NotificationsServiceImpl();
    NotificationsRepository notificationsRepository =
        NotificationsRepositoryImpl(notificationsService);
    NotificationsUseCase notificationsUseCase =
        NotificationsUseCase(notificationsRepository);

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<NavigationBarBloc>(
                create: (context) => NavigationBarBloc(notificationsUseCase)),
          ],
          child: OnboardingWidget(
            notificationsModel: notificationModeList,
            patientName: 'John Doe',
          ),
        ),
      ),
    );
    expect(find.text('Hi there, John Doe 👋'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Appointments'), findsOneWidget);
    expect(find.text('Your Forms'), findsOneWidget);
    expect(find.text('Unread Portal Notes'), findsOneWidget);
    expect(find.text('Access your MedQare Portal'), findsOneWidget);
    expect(
        find.text(
            'Your next appointment is on 22/01/2125 with Dr Gerardo Andrade'),
        findsOneWidget);
  });

  testWidgets('Onboarding of user without Appointnment',
      (WidgetTester tester) async {
    dynamic jsonDataNotificationNotes = {
      "component": "notes",
      "count": 1,
    };

    NotificationsModel notificationModelNote =
        NotificationsModel.fromJson(jsonDataNotificationNotes);

    dynamic jsonDataNotificationNextAppointment = {
      "component": "nextAppointment",
      "count": 0,
      "doctor": null,
      "startTime": null,
    };

    NotificationsModel notificationModelNextAppointment =
        NotificationsModel.fromJson(jsonDataNotificationNextAppointment);

    List<NotificationsModel> notificationModeList = [
      notificationModelNote,
      notificationModelNextAppointment
    ];

    NotificationsService notificationsService = NotificationsServiceImpl();
    NotificationsRepository notificationsRepository =
        NotificationsRepositoryImpl(notificationsService);
    NotificationsUseCase notificationsUseCase =
        NotificationsUseCase(notificationsRepository);

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<NavigationBarBloc>(
                create: (context) => NavigationBarBloc(notificationsUseCase)),
          ],
          child: OnboardingWidget(
            notificationsModel: notificationModeList,
            patientName: 'John Doe',
          ),
        ),
      ),
    );
    expect(find.text('Hi there, John Doe 👋'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Appointments'), findsOneWidget);
    expect(find.text('Your Forms'), findsOneWidget);
    expect(find.text('Unread Portal Notes'), findsOneWidget);
    expect(find.text('Access your MedQare Portal'), findsOneWidget);
    expect(find.text('You do not have any upcoming appointments booked.'),
        findsOneWidget);
  });
}
