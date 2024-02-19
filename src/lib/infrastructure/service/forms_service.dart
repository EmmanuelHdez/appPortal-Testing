import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:src/config/constants/environment_config.dart';
import 'package:src/data/model/forms_model.dart';
import 'package:src/data/model/notifications_model.dart';
import 'package:src/dioCretificate_instance.dart';
import 'package:src/errors/dioException.dart';
import 'package:src/shared/user_preferences.dart';

abstract class FormsService {
  Future<FormsModel> fetchForms(int patientId);
  Future<FormCollectionsTokenModel> getToken(
      int collectionId, int patientId, int userId, bool isDoctor);
}

class FormsServiceImpl implements FormsService {
  CustomDioClient customHttpClient = CustomDioClient();
  UserPreferences userInfo = UserPreferences();

  @override
  Future<FormsModel> fetchForms(int patientId) async {
    final url = '${EnvironmentConfig.baseUrl}/forms/get-forms/${patientId}';
    final headers = {
      'Content-type': 'application/json',
      'x-server-companion': EnvironmentConfig.xServerCompanionAppToken,
      'Authorization': await userInfo.getToken()
    };

    try {
      Dio _dio = customHttpClient.createDioInstance();
      final response = await _dio.get(url, options: Options(headers: headers));
        var bodyResponse = formsModelFromJson(jsonEncode(response.data));
        return bodyResponse;
    } on DioException catch (e) {
      print('[fetchForms] Status Message: ${e.response!.statusCode}');
      throw resposeDioException(e, url);
    }
  }

  @override
  Future<FormCollectionsTokenModel> getToken(
      int collectionId, int patientId, int userId, bool isDoctor) async {
    final url = '${EnvironmentConfig.baseUrlV3}/formCollections/jwt';

    final headers = {
      'x-server-companion': EnvironmentConfig.xServerCompanionAppToken,
      'x-service': EnvironmentConfig.xServiceCompanioApp,
      'Authorization': await userInfo.getToken()
    };
    final body = {
      "collectionId": collectionId,
      "patientId": patientId,
      "userId": userId,
      "isDoctor": isDoctor
    };
    String jsonBody = json.encode(body);
    try {
      Dio _dio = customHttpClient.createDioInstance();
      final response = await _dio.post(
        url,
        data: jsonBody,
        options: Options(headers: headers),
      );
        var bodyResponse =
            formCollectionsTokenModelFromJson(jsonEncode(response.data));
        return bodyResponse;
    } on DioException catch (e) {
      print('[getToken] Status Message: ${e.response!.statusCode}');
      throw resposeDioException(e, url);
    }
  }
}
