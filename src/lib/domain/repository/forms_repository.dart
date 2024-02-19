import 'package:dio/dio.dart';
import 'package:src/data/model/forms_model.dart';
import 'package:src/data/model/notifications_model.dart';
import 'package:src/errors/dioException.dart';
import 'package:src/infrastructure/service/forms_service.dart';

abstract class FormsRepository {
  Future<FormsModel> fetchForms(int patientId);
  Future<FormCollectionsTokenModel> getToken(
      int collectionId, int patientId, int userId, bool isDoctor);
}

class FormsRepositoryImpl extends FormsRepository {
  final FormsService formsService;

  FormsRepositoryImpl(this.formsService);

  @override
  Future<FormsModel> fetchForms(int patientId) async {
    try {
      final request = await formsService.fetchForms(patientId);
      return request;
    } on DioException catch (e) {
      throw resposeDioException(e, '');
    }
  }

  @override
  Future<FormCollectionsTokenModel> getToken(
      int collectionId, int patientId, int userId, bool isDoctor) async {
    try {
      final request = await formsService.getToken(
          collectionId, patientId, userId, isDoctor);
      return request;
    } on DioException catch (e) {
      throw resposeDioException(e, '');
    }
  }
}
