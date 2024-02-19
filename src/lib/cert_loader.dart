import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:src/config/constants/environment_config.dart';
import 'dart:io';


abstract class CertReader {
  static ByteData? cert;
  static Future<void> initialize() async {
    cert = await rootBundle.load('assets/certificate/companionCert.txt');
  }
  static ByteData? getCert() {
    return cert;
  } 
}
abstract class NetworkCertReader {
  static ByteData? cert;
  static Future<Response> _getServerCertificate() async {
    Dio dio = Dio();
    final url =
        '${EnvironmentConfig.baseUrlV3}/ssl';

    final headers = {
      'Content-type': 'application/json',
      'x-server-companion': EnvironmentConfig.xServerCompanionAppToken,
      'x-service': EnvironmentConfig.xServiceCompanioApp,
    };
    final body = {};
    String jsonBody = json.encode(body);
    try {
      final response = await dio.get(url,
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
      print('Error getting SSL certificate: ${e.toString()}');
      throw DioException(
        requestOptions: RequestOptions(path: url),
        error: e.toString(),
      );
    }
  }

  static Future<void> initialize() async {
    try {
      final response = await _getServerCertificate();
      String certContent = response.data;
      certContent = certContent.replaceAll(r'\n', '\n');      
      String tempDir = Directory.systemTemp.path;
      String filePath = '$tempDir/dynamicCertificate.crt';

      File(filePath).writeAsStringSync(certContent, mode: FileMode.write);

      String fileContent = File(filePath).readAsStringSync();
      List<int> bytes = utf8.encode(fileContent);
      ByteData byteData = ByteData.view(Uint8List.fromList(bytes).buffer);
      cert = byteData;      
    } catch (e) {
      print('Error: $e');
    }
  }

  static ByteData? getCert() {
    return cert;
  } 
}
