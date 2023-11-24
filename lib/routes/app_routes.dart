import 'package:flutter/material.dart';
import 'package:application_base/appViews/sign_in_screen/login_screen.dart';
import 'package:application_base/appViews/horizontal_screen/horizontal_screen.dart';
import 'package:application_base/appViews/notification_list_page/notification_list_page.dart';
import 'package:application_base/appViews/home_screen/home_screen.dart';

class AppRoutes {
  static const String loginScreen = '/login_screen';
  static const String notificationListPage = '/notification_list_page';
  static const String horizontalScreen = '/horizontal_screen';
  static const String homeScreenPage = '/home_screen';

  static Map<String, WidgetBuilder> routes = {
    loginScreen: (context) => LoginScreen(),
    homeScreenPage: (contex) => OnboardingScreen(),
    horizontalScreen: (context) => HorizontalScreen(),
    notificationListPage: (context) => NotificationListPage(),
  };
  static Widget getScreenByIndex(int index) {
    switch (index) {
      case 0:
        return OnboardingScreen();
      case 1:
        return LoginScreen();
      default:
        return NotificationListPage();
    }
  }
}
