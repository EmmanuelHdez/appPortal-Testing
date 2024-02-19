import 'package:flutter/material.dart';
import 'package:src/presentation/appViews/welcome_screen/alternative_welcome_screen.dart';
import 'package:src/presentation/appViews/welcome_screen/welcome_screen.dart';
import 'package:src/presentation/appViews/home_screen/home_screen.dart';
import 'package:src/presentation/appViews/logout_screen.dart';
import 'package:src/presentation/appViews/navigation_bar/main_screen.dart';
import 'package:src/presentation/appViews/forms_screen/forms_screen.dart';
import 'package:src/presentation/routes/notes_router.dart';
import 'package:src/presentation/routes/settings_router.dart';
import 'package:src/presentation/routes/appointments_router.dart';

class AppRoutes {
  static const String loginScreen = '/welcome_screen';
  static const String alternativeLoginScreen = '/alternative_welcome_screen';
  static const String appointmentsPage = '/appointments_screen';
  static const String formsScreenPage = '/forms_screen';
  static const String homeScreenPage = '/home_screen';
  static const String mainScreen = '/main_screen';
  static const String settingsPage = '/settings_screen';
  static const String notesPage = '/notes_screen';
  static const String logoutPage = '/logout_screen';

  static Map<String, WidgetBuilder> routes = {
    loginScreen: (context) => const WelcomeScreen(),
    alternativeLoginScreen: (context) => const WelcomeAlternativeScreen(),
    mainScreen: (context) => const MainScreen(),
    homeScreenPage: (contex) => const HomeScreen(),
    formsScreenPage: (context) => const FormsScreen(),
    appointmentsPage: (context) => const AppointmentsRouter(),
    settingsPage: (context) => const SettingsRouter(),
    logoutPage: (context) => const LogoutScreen(),
    notesPage: (context) => const NotesRouter(),
  };
  static Widget getScreenByIndex(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const WelcomeScreen();
      case 3:
        return const FormsScreen();
      case 4:
        return const LogoutScreen();
      default:
        return const HomeScreen();
    }
  }
}
