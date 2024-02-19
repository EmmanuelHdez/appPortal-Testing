import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:src/config/constants/environment_config.dart';
import 'package:src/data/model/upload_photo.model.dart';
import 'package:mime/mime.dart';
import 'package:src/dioCretificate_instance.dart';
import 'package:src/errors/dioException.dart';
import 'package:src/shared/user_preferences.dart';

abstract class UploadFilesService {
  Future<UploadPhotoModel> uploadPhoto(
      int userId, String filePath, String fileName);
}

class UploadFilesServiceImpl implements UploadFilesService {
  CustomDioClient customHttpClient = CustomDioClient();
  UserPreferences userInfo = UserPreferences();

  Future<UploadPhotoModel> uploadPhoto(
      int userId, String filePath, String fileName) async {
    final url =
        '${EnvironmentConfig.baseUrlV3}/attachments/uploadPhoto/$userId';
    final headers = {
      'Content-type': 'multipart/form-data',
      'x-server-companion': EnvironmentConfig.xServerCompanionAppToken,
      'x-service': EnvironmentConfig.xServiceCompanioApp,
      'Authorization': await userInfo.getToken()
    };

    try {
      Dio _dio = customHttpClient.createDioInstance();
      String mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';
      FormData formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(filePath,
            filename: fileName, contentType: MediaType.parse(mimeType)),
      });
      final response = await _dio.post(url,
          data: formData, options: Options(headers: headers));
        var bodyResponse = uploadPhotoModelFromJson(jsonEncode(response.data));
        return bodyResponse;
    } on DioException catch (e) {
      print('[uploadPhoto] Status Message: ${e.response!.statusCode}');
      throw resposeDioException(e, url);
    }
  }
}
