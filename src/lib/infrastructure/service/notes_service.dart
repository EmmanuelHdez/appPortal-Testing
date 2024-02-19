import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:src/config/constants/environment_config.dart';
import 'package:src/data/model/create_note_model.dart';
import 'package:src/data/model/notes_model.dart';
import 'package:src/dioCretificate_instance.dart';
import 'package:src/errors/dioException.dart';
import 'package:src/shared/user_preferences.dart';

abstract class NotesService {
  Future<NotesModel> fetchUnreadNotes(int patientId);
  Future<CreateNoteModel> createNote(
      int patientId, int baseNoteId, String noteBody);
  Future<dynamic> markAsSeen(int noteId);
  Future<dynamic> updateSeenAtByPatient(int patientId);
}

class NotesServiceImpl implements NotesService {
  CustomDioClient customHttpClient = CustomDioClient();
  UserPreferences userInfo = UserPreferences();

  @override
  Future<NotesModel> fetchUnreadNotes(int patientId) async {
    final url =
        '${EnvironmentConfig.baseUrlV3}/notes/${patientId}/unreadNotes?limit=1000';
    final headers = {
      'Content-type': 'application/json',
      'x-server-companion': EnvironmentConfig.xServerCompanionAppToken,
      'x-service': EnvironmentConfig.xServiceCompanioApp,
      'Authorization': await userInfo.getToken()
    };
    try {
      Dio _dio = customHttpClient.createDioInstance();
      final response = await _dio.get(url, options: Options(headers: headers));
      var bodyResponse = notesModelFromJson(jsonEncode(response.data));
      return bodyResponse;
    } on DioException catch (e) {
      print('[fetchUnreadNotes] Status Message: ${e.response!.statusCode}');
      throw resposeDioException(e, url);
    }
  }

  Future<CreateNoteModel> createNote(
      int patientId, int baseNoteId, String noteBody) async {
    final url = '${EnvironmentConfig.baseUrlV3}/notes/createNoteByPatient';
    final headers = {
      'Content-type': 'application/json',
      'x-server-companion': EnvironmentConfig.xServerCompanionAppToken,
      'x-service': EnvironmentConfig.xServiceCompanioApp,
      'Authorization': await userInfo.getToken()
    };
    final body = {
      "noteId": baseNoteId,
      "notesBody": noteBody,
      "patientId": patientId
    };
    String jsonBody = json.encode(body);
    try {
      Dio _dio = customHttpClient.createDioInstance();
      final response = await _dio.post(
        url,
        data: jsonBody,
        options: Options(headers: headers),
      );
      var bodyResponse = createNoteModelFromJson(jsonEncode(response.data));
      return bodyResponse;
    } on DioException catch (e) {
      print('[createNote] Status Message: ${e.response!.statusCode}');
      throw resposeDioException(e, url);
    }
  }

  Future<dynamic> markAsSeen(int noteId) async {
    final url = '${EnvironmentConfig.baseUrlV3}/notes/updateSeenAtApp';
    final headers = {
      'Content-type': 'application/json',
      'x-server-companion': EnvironmentConfig.xServerCompanionAppToken,
      'x-service': EnvironmentConfig.xServiceCompanioApp,
      'Authorization': await userInfo.getToken()
    };

    try {
      Dio _dio = customHttpClient.createDioInstance();
      final body = {
        "noteId": noteId,
      };
      String jsonBody = json.encode(body);
      final response = await _dio.put(
        url,
        data: jsonBody,
        options: Options(headers: headers),
      );
      var bodyResponse = jsonEncode(response.data);
      return bodyResponse;
    } on DioException catch (e) {
      print('[markAsSeen] Status Message: ${e.response!.statusCode}');
      throw resposeDioException(e, url);
    }
  }

  Future<dynamic> updateSeenAtByPatient(int patientId) async {
    final url = '${EnvironmentConfig.baseUrlV3}/notes/updateSeenAtByPatient';
    final headers = {
      'x-server-companion': EnvironmentConfig.xServerCompanionAppToken,
      'x-service': EnvironmentConfig.xServiceCompanioApp,
      'Authorization': await userInfo.getToken()
    };
    final body = {
      "patientId": patientId,
    };
    String jsonBody = json.encode(body);
    try {
      Dio _dio = customHttpClient.createDioInstance();
      final response = await _dio.put(
        url,
        data: jsonBody,
        options: Options(headers: headers),
      );
      var bodyResponse = jsonEncode(response.data);
      return bodyResponse;
    } on DioException catch (e) {
      print(
          '[updateSeenAtByPatient] Status Message: ${e.response!.statusCode}');
      throw resposeDioException(e, url);
    }
  }
}
