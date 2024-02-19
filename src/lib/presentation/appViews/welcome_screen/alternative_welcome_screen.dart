import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:quickalert/quickalert.dart';
import 'package:src/config/config.dart';
import 'package:src/data/model/token_b2c_model.dart';
import 'package:src/dioCretificate_instance.dart';
import 'package:src/main.dart';
import 'package:src/presentation/appViews/appointment_details_screen/appointments_details_screen.dart';
import 'package:src/presentation/appViews/home_screen/webView.dart';
import 'package:src/infrastructure/service/auth_b2c_service.dart';
import 'package:src/presentation/appViews/logout_screen.dart';
import 'package:src/presentation/appViews/note_details_screen/note_details_screen.dart';
import 'package:src/presentation/appViews/welcome_screen/webVIewAuthenticator.dart';
import 'package:src/presentation/appViews/welcome_screen/welcome_screen.dart';
import 'package:src/presentation/routes/app_routes.dart';
import 'package:src/shared/secure_storage.dart';
import 'package:src/shared/user_preferences.dart';
import 'package:src/utils/image_constant.dart';
import 'package:src/utils/size_utils.dart';
import 'package:src/dependency_injection_container.dart';
import 'package:src/presentation/appViews/welcome_screen/bloc/welcome_bloc.dart';
import 'package:src/presentation/shared/loading_widget.dart';
import 'package:src/presentation/widgets/custom_image_view.dart';
import './webView.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class WelcomeAlternativeScreen extends StatelessWidget {
  final NotificationInfo? notificationInfo;
  const WelcomeAlternativeScreen({Key? key, this.notificationInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
            create: (_) => sl<WelcomeBloc>(),
            child: WelcomeWidget(notificationInfo: notificationInfo)));
  }
}

class WelcomeWidget extends StatefulWidget {
  final NotificationInfo? notificationInfo; // Notification Info
  const WelcomeWidget({Key? key, this.notificationInfo}) : super(key: key);

  @override
  State<WelcomeWidget> createState() => _WelcomeWidgetState();
}

class _WelcomeWidgetState extends State<WelcomeWidget> {
  final _discoveryUrl = EnvironmentConfig.aadb2cDiscoveryUri;
  final _clientId = EnvironmentConfig.aadb2cClientId;
  final _redirectURI = EnvironmentConfig.aadb2cRedirectUri;
  final AzureADb2cService _authService = AzureADb2cService();
  final UserPreferences userInfo = UserPreferences();
  final UserCredentials userSensitiveInfo = UserCredentials();
  static final _firebaseMessaging = FirebaseMessaging.instance;
  CustomDioClient customHttpClient = CustomDioClient();
  late final LocalAuthentication auth;
  

  @override
  void initState() {
    auth = LocalAuthentication();
    super.initState();
  }

  void _savePortalToken(TokenB2cModel user) {
    userInfo.saveToken(user.token);
    userInfo.savePatientId(user.patientId);
    userInfo.saveUserId(user.userId);
    userInfo.saveStringValues(USER_FIRSTNAME, user.firstName);
    userInfo.saveStringValues(USER_LASTNAME, user.lastName);
    if (user.prefFirstName != null) {
      userInfo.saveStringValues(USER_PREF_FIRSTNAME, user.prefFirstName);
    }
    if (user.prefMiddleName != null) {
      userInfo.saveStringValues(USER_PREF_MIDDLENAME, user.prefMiddleName);
    }
    if (user.prefLastName != null) {
      userInfo.saveStringValues(USER_PREF_LASTNAME, user.prefLastName);
    }
    userInfo.saveShowSettingsValue(user.showMySettingsApp);
    // Save Sensitive Values Encrypted
    userSensitiveInfo.saveEmailUser(user.email);
    userSensitiveInfo.savePasswordUser(user.password);

    String? configuredMethods = user.authMethods;
    bool hasFingerprint = configuredMethods!.contains("fingerprint");
    if(hasFingerprint) {
      userInfo.saveFingerprintEnabled(true);
    } else {
      userInfo.saveFingerprintEnabled(false);
    }
     // Allow user to use fingerprint
    userInfo.saveFingerprintFirstLogin(true);

  }

  void _showErrorModal([String? message]) {
    // Displays a modal with error message
    QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: message ?? 'Sorry, something went wrong');
  }

  Future<String?> exchangeCodeForToken(
      String? code, String tokenEndpoint) async {
    try {
      final response = await http.post(
        Uri.parse(tokenEndpoint),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': _redirectURI,
          'client_id': _clientId,
          'scope': 'openid'
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String accessToken = data['id_token'];
        return accessToken;
      } else {
        print('Token exchange failed. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during token exchange: $e');
    }
    return null;
  }

  // Process the result received from the WebView
  void _processWebViewResult(dynamic result, String tokenEndpoint) async {
    // Parse the redirect URL
    Uri uri = Uri.parse(result);

    // Get the value of the 'code' parameter
    String? code = uri.queryParameters['code'];

    final String? token = await exchangeCodeForToken(code!, tokenEndpoint);
    userInfo.saveAzureB2CToken(token);
    TokenB2cModel tokenInfo = _authService.decodeToken(token!);
    _savePortalToken(tokenInfo);
    _findPreviouslySeenNotes(tokenInfo);
  }

  // Authentication with Azure B2C
  Future<void> _handleLogin() async {
    try {
      Future<Map<String, dynamic>> fetchOpenIdConfiguration(
          String discoveryUrl) async {
        final response = await http.get(Uri.parse(discoveryUrl));
        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          throw Exception('Failed to fetch OpenID Connect configuration');
        }
      }

      final config = await fetchOpenIdConfiguration(_discoveryUrl);
      final authorizationEndpoint = config['authorization_endpoint'];
      final tokenEndpoint = config['token_endpoint'];

      final authorizationUrl =
          '$authorizationEndpoint&client_id=$_clientId&redirect_uri=$_redirectURI&response_type=code&scope=openid&authorization_user_agent=WEBVIEW';

      // ignore: use_build_context_synchronously
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebViewContainerLogin(
            url: authorizationUrl,
          ),
        ),
      );
      if (result != null) {
        Uri resultUri = Uri.parse(result);
        String? code = resultUri.queryParameters['code'];
        final String? token = await exchangeCodeForToken(code!, tokenEndpoint);
        TokenB2cModel tokenInfo = _authService.decodeToken(token!);

        final fingerprintCompatible = await userInfo.getFingerprintCompatible();  
        final fingerprintFirstLogin = await userInfo.getFingerprintFirstLogin();

        if (tokenInfo.fingerprintAuth == true) {
          if (fingerprintCompatible && fingerprintFirstLogin) {
            bool authenticated = await auth.authenticate(
            localizedReason:
                "Introduce your biometics to continue into the app",
            options: const AuthenticationOptions(
              stickyAuth: true,
              biometricOnly: true,
            ));
            if(authenticated) {
              _processWebViewResult(result, tokenEndpoint);
              return;
            }           
          } else {
            // ignore: use_build_context_synchronously
            MotionToast.error(
              title: const Text(
                'There was an error',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              description: const Text(
                  "Error encountered while attempting to log into the app"),
              animationType: AnimationType.fromTop,
              position: MotionToastPosition.top,
            ).show(context);
            return;
          }
        }

        if (tokenInfo.authenticationApp == true) {
          final email = tokenInfo.email;
          final password = tokenInfo.password;
          // ignore: use_build_context_synchronously
          final authenticatorRes = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewAuthenticator(
                email: email,
                passw: password,
              ),
            ),
          );
          // Check if the widget is still mounted before using the result
          if (authenticatorRes != null) {
            _processWebViewResult(result, tokenEndpoint);
          }
        } else {
          _processWebViewResult(result, tokenEndpoint);
        }
      }
    } catch (e, stackTrace) {
      print('Exception type: ${e.runtimeType}');
      print('Exception message: $e');
      print('Stack trace: $stackTrace');
    }
  }

  Future saveFcmTokenRequest(String userId, String token) async {
    final url =
        '${EnvironmentConfig.baseUrlV3}/firebaseNotification/mobileTokens/$userId';
    final headers = {
      'Content-type': 'application/json',
      'x-server-companion': EnvironmentConfig.xServerCompanionAppToken,
      'x-service': EnvironmentConfig.xServiceCompanioApp,
      'Authorization': await userInfo.getToken()
    };
    final body = {
      'token': token,
    };
    String jsonBody = json.encode(body);

    try {
      Dio dio = customHttpClient.createDioInstance();
      final response = await dio.post(url,
          options: Options(headers: headers), data: jsonBody);
      if (response.statusCode == 200) {
        return response;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Server error',
        );
      }
    } catch (e) {
      print('Error saving fcm token: ${e.toString()}');
      throw DioException(
        requestOptions: RequestOptions(path: url),
        error: e.toString(),
      );
    }
  }

  // Find notes that were viewed at the previous login
  void _findPreviouslySeenNotes(TokenB2cModel tokenInfo) {
    try {
      context
          .read<WelcomeBloc>()
          .add(UpdateSeenAtField(tokenInfo.patientId, tokenInfo));
    } catch (e) {
      print('error $e');
    }
  }

  static Future _getToken() async {
    final fcmToken = await _firebaseMessaging.getToken();
    return fcmToken;
  }

  void _redirect2Screen() {
    if (widget.notificationInfo != null) {
      String notificationType = widget.notificationInfo!.typeNotification;
      print("Notification Type: $notificationType");
      if (notificationType == "Appointments") {
        dynamic notificationData = widget.notificationInfo!.data;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => AppointmentsDetailsScreen(
                      notificationTap: true,
                      appointmentIdArg: notificationData,
                    )));
      }
      if (notificationType == "Notes") {
        dynamic notificationData = widget.notificationInfo!.data;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NoteDetailsScreen(
              notificationTap: true,
              noteDataArgs: notificationData,
            ),
          ),
        );
      }
      if (notificationType == "Forms") {
        dynamic notificationData = widget.notificationInfo!.data;
        print(notificationData.runtimeType);
        String url = notificationData["url"];
        String requiredMessage = notificationData["requiredMessage"];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewContainer(
                url: url,
                nameRoute: AppRoutes.formsScreenPage,
                messagePin: requiredMessage),
          ),
        );
      }
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WelcomeBloc, WelcomeState>(
        listener: (context, state) async {
      if (state is WelcomeLoading) {
        LoadingDialog.show(context);
      } else if (state is SeenAtFieldUpdated) {
        LoadingDialog.hide(context);
        final TokenB2cModel user = state.user;
        String userId = user.patientId.toString();
        final token = await _getToken();
        saveFcmTokenRequest(userId, token);
        _redirect2Screen();
      } else if (state is WelcomeError) {
        LoadingDialog.hide(context);
        if (state.message == 401 || state.message == '401') {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LogoutScreen()),
              (Route<dynamic> route) => false,
            );
          });
        } else {
          _showErrorModal('Sorry, something went wrong');
        }
      }
    }, child: BlocBuilder<WelcomeBloc, WelcomeState>(builder: (context, state) {
      return SafeArea(
        child: Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            body: OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.portrait) {
                  return _content();
                } else {
                  return Stack(
                    fit: StackFit.expand,
                    children: [_content()],
                  );
                }
              },
            )),
      );
    }));
  }

  Widget _content() {
    double smallRegisteredText =
        SizeUtils.calculateSmallRegisteredText(context);

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Spacer(flex: 1),
      Container(
        alignment: Alignment.center,
        child: CustomImageView(
          imagePath: ImageConstant.logoWelcomeScreen,
          margin: const EdgeInsets.only(bottom: 25),
          width: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width < 600
                  ? getHorizontalSize(95)
                  : getHorizontalSize(70)
              : MediaQuery.of(context).size.width < 1000
                  ? getHorizontalSize(90)
                  : getHorizontalSize(100),
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Text(
              "You are logged out of the app",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF2A3786),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 35.0),
        child: ElevatedButton(
          onPressed: _handleLogin,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            side: const BorderSide(color: Color(0xFF6048DE)),
            backgroundColor: const Color(0xFF6048DE),
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 14.0,
            ),
            fixedSize: const Size.fromWidth(260.0),
          ),
          child: Text(
            'Log in here'.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ),
      ),
      const Spacer(flex: 1),
      Padding(
        padding: const EdgeInsets.only(bottom: 24, top: 25),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            'Powered by Psychiatry-UK',
            style: TextStyle(
              fontSize: smallRegisteredText,
              color: Color(0xFF94a3b8),
            ),
          ),
        ),
      ),
    ]);
  }
}

class LoadingDialog {
  static void show(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const LoadingWidget());
  }

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }
}
