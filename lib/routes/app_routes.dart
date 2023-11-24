import 'package:flutter/material.dart';
import 'package:application_base/appViews/splash_screen/splash_screen.dart';
import 'package:application_base/appViews/horizontal_screen/horizontal_screen.dart';
import 'package:application_base/appViews/app_navigation_screen/app_navigation_screen.dart';
import 'package:application_base/appViews/notification_list_page/notification_list_page.dart';
import 'package:application_base/appViews/home_screen/home_screen.dart';

class AppRoutes {
  static const String splashScreen = '/splash_screen';
  static const String notificationListPage = '/notification_list_page';
  static const String horizontalScreen = '/horizontal_screen';
  static const String appNavigationScreen = '/app_navigation_screen';
  static const String homeScreenPage = '/home_screen';

  static Map<String, WidgetBuilder> routes = {
    splashScreen: (context) => SplashScreen(),
    horizontalScreen: (context) => HorizontalScreen(),
    appNavigationScreen: (context) => AppNavigationScreen(),
    notificationListPage: (context) => NotificationListPage(),
    homeScreenPage: (contex) => OnboardingScreen()
  };
}
