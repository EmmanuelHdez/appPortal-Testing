import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:src/config/config.dart';
import 'package:src/data/model/notifications_model.dart';
import 'package:src/dioCretificate_instance.dart';
import 'package:src/errors/dioException.dart';
import 'package:src/shared/shared_preferences.dart';
import 'package:src/shared/user_preferences.dart';

abstract class NotificationsService {
  Future<List<NotificationsModel>> fetchNotifications(int patientId);
  Future<NotificationSettingsModel> getNotificationSettings(int userId);
  Future<NotificationResponseModel> saveNotificationSettings(
      int userId, String notificationSetting);
  Future<dynamic> validateNotificationsScreen(int showSettingsValue);
}

class NotificationsServiceImpl implements NotificationsService {
  CustomDioClient customHttpClient = CustomDioClient();
  UserPreferences userInfo = UserPreferences();
  @override
  Future<List<NotificationsModel>> fetchNotifications(int patientId) async {
    final url = '${EnvironmentConfig.baseUrl}/notifications/$patientId';
    try {
      Dio _dio = customHttpClient.createDioInstance();
      final headers = {
        'Content-type': 'application/json',
        'x-server-companion': EnvironmentConfig.xServerCompanionAppToken,
        'Authorization': await userInfo.getToken()
      };
      final response = await _dio.get(url, options: Options(headers: headers));
      var bodyResponse = notificationsModelFromJson(jsonEncode(response.data));
      return bodyResponse;
    } on DioException catch (e) {
      print('[fetchNotifications] Status Message: ${e.response!.statusCode}');
      throw resposeDioException(e, url);
    }
  }

  @override
  Future<NotificationSettingsModel> getNotificationSettings(int userId) async {
    final url = '${EnvironmentConfig.baseUrlV3}/notification-setting';
    try {
      Dio _dio = customHttpClient.createDioInstance();
      final headers = {
        'Content-type': 'application/json',
        'x-server-companion': EnvironmentConfig.xServerCompanionAppToken,
        'x-service': EnvironmentConfig.xServiceCompanioApp,
        'Authorization': await userInfo.getToken()
      };
      Map<String, dynamic> queryParams = {'userId': userId};
      final response = await _dio.get(url,
          queryParameters: queryParams, options: Options(headers: headers));
      var bodyResponse =
          notificationSettingsModelFromJson(jsonEncode(response.data));
      return bodyResponse;
    } on DioException catch (e) {
      print(
          '[getNotificationSettings] Status Message: ${e.response!.statusCode}');
      throw resposeDioException(e, url);
    }
  }

  Future<NotificationResponseModel> saveNotificationSettings(
      int userId, String notificationSetting) async {
    final url = '${EnvironmentConfig.baseUrlV3}/notification-setting';
    try {
      Dio _dio = customHttpClient.createDioInstance();
      final headers = {
        'Content-type': 'application/json',
        'x-server-companion': EnvironmentConfig.xServerCompanionAppToken,
        'x-service': EnvironmentConfig.xServiceCompanioApp,
        'Authorization': await userInfo.getToken()
      };
      final body = {
        "userId": userId,
        "notificationSetting": notificationSetting,
      };
      String jsonBody = json.encode(body);
      final response = await _dio.put(
        url,
        data: jsonBody,
        options: Options(headers: headers),
      );
      var bodyResponse =
          notificationResponseModelFromJson(jsonEncode(response.data));
      return bodyResponse;
    } on DioException catch (e) {
      print(
          '[saveNotificationSettings] Status Message: ${e.response!.statusCode}');
      throw resposeDioException(e, url);
    }
  }

  Future<dynamic> validateNotificationsScreen(int showSettingsValue) async {
    final url = '${EnvironmentConfig.baseUrlV3}/displayConfigModal';
    try {
      final patientId =
          await MySharedPreferences.instance.getIntValue(PATIENT_ID);
      Dio _dio = customHttpClient.createDioInstance();
      final headers = {
        'Content-type': 'application/json',
        'x-server-companion': EnvironmentConfig.xServerCompanionAppToken,
        'x-service': EnvironmentConfig.xServiceCompanioApp,
        'Authorization': await userInfo.getToken()
      };
      final body = {
        "patientId": patientId,
        "showSettingsValue": showSettingsValue,
      };
      String jsonBody = json.encode(body);
      final response = await _dio.post(
        url,
        data: jsonBody,
        options: Options(headers: headers),
      );
      var bodyResponse = json.decode(json.encode(response.data));
      return bodyResponse;
    } on DioException catch (e) {
      print(
          '[validateNotificationsScreen] Status Message: ${e.response!.statusCode}');
      throw resposeDioException(e, url);
    }
  }
}
