import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:src/config/constants/environment_config.dart';
import 'package:src/data/model/pref_auth_methods_model.dart';
import 'package:src/data/model/put_pref_auth_methods_res_model.dart';
import 'package:src/errors/dioException.dart';
import 'package:src/shared/user_preferences.dart';

abstract class PrefAuthMethodsService {
  Future<PrefauthMethodsModel> fetchPrefAuthMethods(int patientId);
  Future<PutPrefauthMethodsResModel> updatePrefauthMethods(
      int patientId, dynamic putBody);
}

class PrefAuthMethodsServiceImpl implements PrefAuthMethodsService {
  final Dio _dio = Dio();
  UserPreferences userInfo = UserPreferences();

  @override
  Future<PrefauthMethodsModel> fetchPrefAuthMethods(int patientId) async {
    final url = '${EnvironmentConfig.baseUrlV3}/prefAuthMethods/${patientId}';
    final headers = {
      'Content-type': 'application/json',
      'x-server-companion': EnvironmentConfig.xServerCompanionAppToken,
      'x-service': EnvironmentConfig.xServiceCompanioApp,
      'Authorization': await userInfo.getToken()
    };
    try {
      final response = await _dio.get(url, options: Options(headers: headers));
      var bodyResponse =
          prefauthMethodsModelFromJson(jsonEncode(response.data));
      return bodyResponse;
    } on DioException catch (e) {
      print('[fetchPrefAuthMethods] Status Message: ${e.response!.statusCode}');
      throw resposeDioException(e, url);
    }
  }

  Future<PutPrefauthMethodsResModel> updatePrefauthMethods(
      int patientId, dynamic putBody) async {
    final url = '${EnvironmentConfig.baseUrlV3}/prefAuthMethods/${patientId}';

    final headers = {
      'Content-type': 'application/json',
      'x-server-companion': EnvironmentConfig.xServerCompanionAppToken,
      'x-service': EnvironmentConfig.xServiceCompanioApp,
      'Authorization': await userInfo.getToken()
    };

    final body = {
      "sms": putBody['sms'],
      "call": putBody['call'],
      "email": putBody['email'],
      "fingerprint": putBody['fingerprint'],
      "authenticatorApp": putBody['authenticatorApp'],
    };

    String jsonBody = json.encode(body);
    try {
      final response = await _dio.put(
        url,
        data: jsonBody,
        options: Options(headers: headers),
      );
      var bodyResponse =
          putPrefauthMethodsResModelFromJson(jsonEncode(response.data));
      return bodyResponse;
    } on DioException catch (e) {
      print(
          '[updatePrefauthMethods] Status Message: ${e.response!.statusCode}');
      throw resposeDioException(e, url);
    }
  }
}
