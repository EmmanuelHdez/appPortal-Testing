import 'package:application_base/appViews/home_screen/home_screen.dart';
import 'package:application_base/appViews/horizontal_screen/horizontal_screen.dart';
import 'package:application_base/appViews/notification_list_page/notification_list_page.dart';
import 'package:application_base/appViews/sign_in_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:application_base/core/app_export.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = OnboardingScreen();
        break;
      case 1:
        page = NotificationListPage();
        break;
      case 2:
        page = HorizontalScreen();
        break;
      default:
        page = LoginScreen();
    }

    var selectedPage = AnimatedSwitcher(
      duration: Duration(milliseconds: 400),
      child: page,
    );

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Expanded(child: selectedPage),
          SafeArea(
            child: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notification_add),
                  label: 'Notifications',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.navigation),
                  label: 'Navigation',
                ),
              ],
              currentIndex: selectedIndex,
              onTap: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
