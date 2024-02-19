import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:src/config/constants/environment_config.dart';
import 'package:src/data/model/account_model.dart';
import 'package:src/dioCretificate_instance.dart';
import 'package:src/errors/dioException.dart';
import 'package:src/shared/user_preferences.dart';

abstract class AccountService {
  Future<AccountModel> fetchPatient(int patientId);
}

class AccountServiceImpl implements AccountService {
  CustomDioClient customHttpClient = CustomDioClient();
  UserPreferences userInfo = UserPreferences();
  @override
  Future<AccountModel> fetchPatient(int patientId) async {
    final url = '${EnvironmentConfig.baseUrl}/yourAccount/$patientId';
    final headers = {
      'Content-type': 'application/json',
      'x-server-companion': EnvironmentConfig.xServerCompanionAppToken,
      'Authorization': await userInfo.getToken()
    };
    try {
      Dio _dio = customHttpClient.createDioInstance();
      final response = await _dio.get(url, options: Options(headers: headers));
      var bodyResponse = accountModelFromJson(jsonEncode(response.data));
      return bodyResponse;
    } on DioException catch (e) {
      print('[fetchPatient] Status Message: ${e.response!.statusCode}');
      throw resposeDioException(e, url);
    }
  }
}
