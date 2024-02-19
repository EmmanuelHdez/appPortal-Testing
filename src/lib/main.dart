import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:src/cert_loader.dart';
import 'package:src/config/config.dart';
import 'package:src/data/model/form_notification_model.dart';
import 'package:src/data/model/notes_model.dart';
import 'package:src/dependency_injection_container.dart' as di;
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:src/presentation/appViews/appointment_details_screen/appointments_details_screen.dart';
import 'package:src/presentation/appViews/home_screen/webView.dart';
import 'package:src/presentation/appViews/note_details_screen/note_details_screen.dart';
import 'package:src/presentation/appViews/welcome_screen/alternative_welcome_screen.dart';
import 'package:src/presentation/appViews/welcome_screen/welcome_screen.dart';
import 'package:src/pushNotifications/push_notifications.dart';
import 'package:src/utils/device_information.dart';
import 'firebase_options.dart';
import 'package:src/presentation/routes/app_routes.dart';
import 'package:src/shared/user_preferences.dart';
import './utils/session_listener.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:http/io_client.dart';



final navigatorKey = GlobalKey<NavigatorState>();

// Funtion that is responable to lisen to background changes on the app
Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("Some notification Received");
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Data: ${message.data}');
  }
}
class NotificationInfo {
  final String typeNotification;
  final dynamic data;
  NotificationInfo({required this.typeNotification, required this.data});
}

Future<SecurityContext> get globalContext async {
  final sslCert = await rootBundle.load('assets/certificate/certificate.pem');
  SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
  securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
  return securityContext;
}

Future<http.Client> getSSLPinningClient() async {
  HttpClient client = HttpClient(context: await globalContext);
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => false;
  IOClient ioClient = IOClient(client);
  return ioClient;
}
Future<bool> verifyPortalToken() async {
  final url = '${EnvironmentConfig.baseUrlV3}/verify-auth-token';  

  final UserPreferences userInfo = UserPreferences();
  final headers = {
    'Content-type': 'application/json',
    'x-server-companion': EnvironmentConfig.xServerCompanionAppToken,
    'x-service': EnvironmentConfig.xServiceCompanioApp,
    'authorization': await userInfo.getToken(),
  };
  final body = {};
  String jsonBody = json.encode(body);
  try {
    Dio dio = Dio();
    final response =
        await dio.post(url, options: Options(headers: headers), data: jsonBody);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print('Error authentication token: ${e.toString()}');
    return false;
  }
}

void handleNotification(RemoteMessage message,
    {required bool isAlternativeScreen}) {
    final notificationType = message.data['type'];

    NotificationInfo? notificationInfo;
    switch (notificationType) {
      case "Appointments":
        notificationInfo = handleAppointmentNotification(message);
        break;
      case "Notes":
        notificationInfo = handleNotesNotification(message);
        break;
      case "Forms":
        notificationInfo = handleFormsNotification(message);
        break;
      default:
        print("Unknown notification type: $notificationType");
    }

    if (notificationInfo != null) {
      final routeBuilder = isAlternativeScreen
          ? (context) =>
              WelcomeAlternativeScreen(notificationInfo: notificationInfo)
          : (context) => WelcomeScreen(
              notificationInfo: notificationInfo, openNotification: true);

      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: routeBuilder,
        ),
      );
    }  
}

void handleValidNotifications(RemoteMessage message) {
  final notificationType = message.data['type'];

  NotificationInfo? notificationInfo;
  switch (notificationType) {
    case "Appointments":
      notificationInfo = handleAppointmentNotification(message);
      if (notificationInfo != null) {
        dynamic notificationData = notificationInfo.data;
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => AppointmentsDetailsScreen(
                notificationTap: true, appointmentIdArg: notificationData),
          ),
        );
      }
      break;
    case "Notes":
      notificationInfo = handleNotesNotification(message);
      if (notificationInfo != null) {
        dynamic notificationData = notificationInfo.data;
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => NoteDetailsScreen(
                notificationTap: true, noteDataArgs: notificationData),
          ),
        );
      }
      break;
    case "Forms":
      notificationInfo = handleFormsNotification(message);
      if (notificationInfo != null) {
        dynamic notificationData = notificationInfo.data;
        String url = notificationData["url"];
        String requiredMessage = notificationData["requiredMessage"];
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => WebViewContainer(
                url: url,
                nameRoute: AppRoutes.formsScreenPage,
                messagePin: requiredMessage),
          ),
        );
      }
      break;
    default:
      print("Unknown notification type: $notificationType");
  }
}



NotificationInfo? handleAppointmentNotification(RemoteMessage message) {
  final appointmentIdString = message.data['appointmentId'];
  if (appointmentIdString == null) {
    return null;
  }
  int appointmentId = int.parse(appointmentIdString);
  print("Converted appointmentId: $appointmentId");
  return NotificationInfo(
      typeNotification: "Appointments", data: appointmentId);
}

NotificationInfo? handleNotesNotification(RemoteMessage message) {
  final noteData = message.data['noteData'];  
  final bodyResponse = noteModelFromJson(noteData);
  return NotificationInfo(typeNotification: "Notes", data: bodyResponse);
}

NotificationInfo? handleFormsNotification(RemoteMessage message) {
  final tokenForm = message.data['token'];
  final requiredMessage = message.data['body'];  
  final result = json.decode(message.data['form']);
  final bodyResponse = formNotificationFromJson(jsonEncode(result));
   String? formUrl = bodyResponse.locked == 1
              ? bodyResponse.formViewUrl
              : bodyResponse.formEditUrl;
          formUrl = "$formUrl?jwt=$tokenForm";
  return NotificationInfo(typeNotification: "Forms", data: {"url": formUrl, "requiredMessage": requiredMessage});
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); 
  final UserPreferences userPreferences = UserPreferences();

  // Determine if device is compatible with fingerprint
  late final LocalAuthentication auth;
  auth = LocalAuthentication();
  await auth.isDeviceSupported().then((bool isSupported) {
    userPreferences.saveFingerprintCompatible(isSupported);
  });

  // on background notification tapped
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    final UserPreferences userInfo = UserPreferences();
    final tokeninfo = await userInfo.getAzureToken();
    final patientId = await userInfo.getPatientId();
    final fingerprintEnabled = await userInfo.getFingerprintEnabled();

    if (tokeninfo.isNotEmpty && patientId != 0) {
      bool tokenIsValid = await verifyPortalToken();
      if (!tokenIsValid) {
         if (fingerprintEnabled) {
          handleNotification(message, isAlternativeScreen: false);
        } else {
          handleNotification(message, isAlternativeScreen: true);
        }   
      } else {
        handleValidNotifications(message);
      }      
    } else {
      handleNotification(message, isAlternativeScreen: true);
    }    
  });
  
  

  PushNotifications.initNotification();
  PushNotifications.localNotificationsInit();
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

  // Handle the foreground notifications when using the app
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payload = jsonEncode(message.data);
    print("Recieved foreground notification");
    if (message.notification != null) {
      PushNotifications.showSimpleNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: payload);
    }
  });

  final RemoteMessage? message =
      await FirebaseMessaging.instance.getInitialMessage();
  final UserPreferences userInfo = UserPreferences();
  final tokeninfo = await userInfo.getAzureToken();
  final patientId = await userInfo.getPatientId();
  final fingerprintEnabled = await userInfo.getFingerprintEnabled();

  if (tokeninfo.isNotEmpty && patientId != 0) { 
    if (message!=null) { 
      bool tokenIsValid = await verifyPortalToken();
      if (!tokenIsValid) {
        if (fingerprintEnabled) {
          Future.delayed(const Duration(seconds: 2), () { 
            handleNotification(message, isAlternativeScreen: false);
          });
        } else {
          Future.delayed(const Duration(seconds: 2), () { 
             handleNotification(message, isAlternativeScreen: true);
          });
        }        
      } else {
        Future.delayed(const Duration(seconds: 2), () { 
          handleValidNotifications(message);
        });
      }
    }
  } else {
    if (message!=null) {
      Future.delayed(const Duration(seconds: 2), () { 
        handleNotification(message, isAlternativeScreen: true);
      });
    }
  }    

  // Load SSL certification to use always on app
  await CertReader.initialize();
  await NetworkCertReader.initialize();

  //Mobile information device

  String ip = await DeviceInformation.ipv4();
  userPreferences.saveStringValues(DEVICE_PUBLIC_IP, ip);
  String deviceOS = await DeviceInformation.getDeviceSO();
  userPreferences.saveStringValues(DEVICE_OS, deviceOS);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Dependency injection  
  await di.init();

  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool? _jailbroken;
  bool? _developerMode;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    bool jailbroken;
    bool developerMode;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      jailbroken = await FlutterJailbreakDetection.jailbroken;
      developerMode = await FlutterJailbreakDetection.developerMode;
    } on PlatformException {
      jailbroken = true;
      developerMode = true;
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _jailbroken = jailbroken;
      _developerMode = developerMode;
    });
    // if (_jailbroken == true) {
    //   _handleJailbreakDetected();
    // }
  }

  void _handleJailbreakDetected() {
    print("Jailbreak Developer Mode detected. Exiting application.");
    SystemNavigator.pop();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SessionTimeoutListener(
      duration: const Duration(minutes: 20),
      onTimeOut: () {
        print("Redirecting");
        Future.microtask(() async {
          final UserPreferences userInfo = UserPreferences();
          final info = await userInfo.getAzureToken(); 
          if (info.isNotEmpty) {
            userInfo.removePortalToken();
            navigatorKey.currentState?.pushReplacement(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => const WelcomeScreen(),
              ),
            );
            // ignore: use_build_context_synchronously
            MotionToast.warning(
              title: const Text(
                'Session expired',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              description:
                  const Text("Due to inactivity you have been logged out"),
              animationType: AnimationType.fromTop,
              position: MotionToastPosition.top,
            ).show(context);
          }
        });
      },
      child: MaterialApp(
        title: 'PUK Patient Portal App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          visualDensity: VisualDensity.standard,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(41, 55, 134, 1)),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        initialRoute: AppRoutes.loginScreen,
        navigatorKey: navigatorKey,
        routes: AppRoutes.routes,
      ),
    );
  }
}
