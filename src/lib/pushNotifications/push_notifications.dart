import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:src/config/constants/environment_config.dart';
import 'package:src/data/model/form_notification_model.dart';
import 'package:src/data/model/notes_model.dart';
import 'package:src/main.dart';
import 'package:src/presentation/appViews/appointment_details_screen/appointments_details_screen.dart';
import 'package:src/presentation/appViews/home_screen/webView.dart';
import 'package:src/presentation/appViews/note_details_screen/note_details_screen.dart';
import 'package:src/presentation/appViews/welcome_screen/alternative_welcome_screen.dart';
import 'package:src/presentation/appViews/welcome_screen/welcome_screen.dart';
import 'package:src/presentation/routes/app_routes.dart';
import 'package:src/shared/user_preferences.dart';

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

void handleNotification(Map payload, {required bool isAlternativeScreen}) {
  final notificationType = payload['type'];

  NotificationInfo? notificationInfo;
  switch (notificationType) {
    case "Appointments":
      notificationInfo = handleAppointmentNotification(payload);
      break;
    case "Notes":
      notificationInfo = handleNotesNotification(payload);
      break;
    case "Forms":
      notificationInfo = handleFormsNotification(payload);
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

void handleValidNotifications(Map payload) {
  final notificationType = payload['type'];
  NotificationInfo? notificationInfo;
  switch (notificationType) {
    case "Appointments":
      notificationInfo = handleAppointmentNotification(payload);
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
      notificationInfo = handleNotesNotification(payload);
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
      notificationInfo = handleFormsNotification(payload);
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

NotificationInfo? handleAppointmentNotification(Map payload) {
  final appointmentIdString = payload['appointmentId'];
  if (appointmentIdString == null) {
    return null;
  }
  int appointmentId = int.parse(appointmentIdString);
  print("Converted appointmentId: $appointmentId");
  return NotificationInfo(
      typeNotification: "Appointments", data: appointmentId);
}

NotificationInfo? handleNotesNotification(Map payload) {
  final noteData = payload['noteData'];
  final bodyResponse = noteModelFromJson(noteData);
  return NotificationInfo(typeNotification: "Notes", data: bodyResponse);
}

NotificationInfo? handleFormsNotification(Map payload) {
  final tokenForm = payload['token'];
  final requiredMessage = payload['body'];
  final result = json.decode(payload['form']);
  final bodyResponse = formNotificationFromJson(jsonEncode(result));

  String? formUrl = bodyResponse.locked == 1
      ? bodyResponse.formViewUrl
      : bodyResponse.formEditUrl;
  formUrl = "$formUrl?jwt=$tokenForm";
  return NotificationInfo(
      typeNotification: "Forms",
      data: {"url": formUrl, "requiredMessage": requiredMessage});
}

class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Request User permission to push notifications
  static Future initNotification() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // get the device fcm token that will be used to send the notification
    final fcmToken = await _firebaseMessaging.getToken();
    print("device token: $fcmToken");
  }

  // initalize local notifications
  static Future localNotificationsInit() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  // on tap local notification in foreground
  static void onNotificationTap(
      NotificationResponse notificationResponse) async {
    Map payload = {};
    payload = jsonDecode(notificationResponse.payload!);
    final UserPreferences userInfo = UserPreferences();
    final tokeninfo = await userInfo.getAzureToken();
    final patientId = await userInfo.getPatientId();
    final fingerprintEnabled = await userInfo.getFingerprintEnabled();

    if (tokeninfo.isNotEmpty && patientId != 0) {
      if (payload != {}) {
        bool tokenIsValid = await verifyPortalToken();
        if (!tokenIsValid) {
          if (fingerprintEnabled) {
            handleNotification(payload, isAlternativeScreen: false);
          } else {
            handleNotification(payload, isAlternativeScreen: true);
          }
        } else {
          handleValidNotifications(payload);
        }
      }
    } else {
      if (payload != {}) {
        handleNotification(payload, isAlternativeScreen: true);
      }
    }
  }

  // show a simple notification
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('psychiatryuk', 'psychiatryuk channel',
            channelDescription: 'Channel to send notifications',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }
}
