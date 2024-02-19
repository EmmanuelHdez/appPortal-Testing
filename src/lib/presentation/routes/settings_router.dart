import 'package:flutter/material.dart';
import 'package:src/presentation/appViews/account_screen/account_screen.dart';
import 'package:src/presentation/appViews/help_screen/help_screen.dart';
import 'package:src/presentation/appViews/notifications_preferences_screen/notifications_preferences_screen.dart';
import 'package:src/presentation/appViews/security_screen/pref_auth_methods_screen.dart';
import 'package:src/presentation/appViews/settings_screen/settings_screen.dart';

class SettingsRouter extends StatelessWidget {
  const SettingsRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/settings_screen/account':
            return MaterialPageRoute(
                builder: (BuildContext context) => const AccountScreen());
          case '/settings_screen/notifications':
            return MaterialPageRoute(
                builder: (BuildContext context) =>
                    const NotificationsPreferencesScreen());
          case '/settings_screen/authConfig':
            return MaterialPageRoute(
                builder: (BuildContext context) =>
                    const PrefAuthMethodsScreen());
          case '/settings_screen/help':
            return MaterialPageRoute(
                builder: (BuildContext context) => const HelpSettings());
          default:
            return MaterialPageRoute(
                builder: (BuildContext context) => SettingsScreen());
        }
      }),
    );
  }
}
