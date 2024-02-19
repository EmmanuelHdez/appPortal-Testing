import 'package:flutter/material.dart';
import 'package:src/config/constants/environment_config.dart';
import 'package:src/presentation/appViews/welcome_screen/webView.dart';
import 'package:src/presentation/appViews/welcome_screen/welcome_screen.dart';
import 'package:src/presentation/appViews/home_screen/webView.dart';
import 'package:src/shared/secure_storage.dart';
import 'package:src/shared/user_preferences.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({Key? key}) : super(key: key);

  @override
  _LogoutScreenState createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  @override
  void initState() {
    super.initState();
    _performAdditionalNavigation();
  }

  Future<void> _performAdditionalNavigation() async {
    try {
      final String logoutUrl = EnvironmentConfig.aadb2cLogoutUri;
      final String logoutRedirectURL =
          EnvironmentConfig.aadb2cLogoutRedirectUri;
      final UserPreferences userInfo = UserPreferences();
      final UserCredentials userSensitiveInfo = UserCredentials();

      userInfo.removeCurrentUser();
      userSensitiveInfo.removeUserCredentials();

      await Future.delayed(const Duration(seconds: 1));
      // ignore: use_build_context_synchronously
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewContainerLogin(
                  url: '$logoutUrl&post_logout_redirect_uri=$logoutRedirectURL',
                )),
      );
    } catch (e) {
      print('Error during additional navigation: $e');
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'You are being logged out',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2A3786),
          ),
        ),
      ),
    );
  }
}
