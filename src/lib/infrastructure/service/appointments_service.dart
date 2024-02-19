import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:src/config/constants/environment_config.dart';
import 'package:intl/intl.dart';
import 'package:src/data/model/appointment_info_model.dart';
import 'package:src/data/model/appointments_model.dart';
import 'package:src/data/model/past_appointments_model.dart';
import 'package:src/dioCretificate_instance.dart';
import 'package:src/errors/dioException.dart';
import 'package:src/shared/user_preferences.dart';

abstract class AppointmentsService {
  Future<AppointmentsModel> fetchFutureAppointments(int patientId);
  Future<PastAppointmentsModel> fetchPastAppointments(int patientId);
  Future<AppointmentInfoModel> fetchAppointmentInfo(int appointmentId);
}

class AppointmentsServiceImpl implements AppointmentsService {
  CustomDioClient customHttpClient = CustomDioClient();
  UserPreferences userInfo = UserPreferences();
  @override
  Future<AppointmentsModel> fetchFutureAppointments(int patientId) async {
    final url =
        '${EnvironmentConfig.baseUrl}/appointments/future-apointments/${patientId}';
    final headers = {
      'Content-type': 'application/json',
      'x-server-companion': EnvironmentConfig.xServerCompanionAppToken,
      'Authorization': await userInfo.getToken()
    };

    try {
      Dio _dio = customHttpClient.createDioInstance();
      final response = await _dio.get(url, options: Options(headers: headers));
      var bodyResponse = appointmentsModelFromJson(jsonEncode(response.data));
      return bodyResponse;
    } on DioException catch (e) {
      print(
          '[fetchFutureAppointments] Status Message: ${e.response!.statusCode}');
      throw resposeDioException(e, url);
    }
  }

  @override
  Future<PastAppointmentsModel> fetchPastAppointments(int patientId) async {
    DateTime now = DateTime.now();
    String formattedTime =
        DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(now.toUtc());

    final url =
        '${EnvironmentConfig.baseUrlV3}/appointments/${patientId}?endTime=lte:${formattedTime}&status=!Cancelled&genericMeeting=0&limit=100&offset=0&order_by=startTime&order_dir=DESC';
    final headers = {
      'Content-type': 'application/json',
      'x-server-companion': EnvironmentConfig.xServerCompanionAppToken,
      'x-service': EnvironmentConfig.xServiceCompanioApp,
      'Authorization': await userInfo.getToken()
    };
    try {
      Dio _dio = customHttpClient.createDioInstance();
      final response = await _dio.get(url, options: Options(headers: headers));
      var bodyResponse =
          pastAppointmentsModelFromJson(jsonEncode(response.data));
      return bodyResponse;
    } on DioException catch (e) {
      print(
          '[fetchPastAppointments] Status Message: ${e.response!.statusCode}');
      throw resposeDioException(e, url);
    }
  }

  @override
  Future<AppointmentInfoModel> fetchAppointmentInfo(int appointmentId) async {
    final url = '${EnvironmentConfig.baseUrl}/appointments/$appointmentId';
    final headers = {
      'Content-type': 'application/json',
      'x-server-companion': EnvironmentConfig.xServerCompanionAppToken,
      'Authorization': await userInfo.getToken()
    };
    try {
      Dio _dio = customHttpClient.createDioInstance();
      final response = await _dio.get(url, options: Options(headers: headers));
      var bodyResponse =
          appointmentInfoModelFromJson(jsonEncode(response.data));
      return bodyResponse;
    } on DioException catch (e) {
      print('[fetchAppointmentInfo] Status Message: ${e.response!.statusCode}');
      throw resposeDioException(e, url);
    }
  }
}
