import 'package:dio/dio.dart';
import 'package:src/errors/dioException.dart';
import 'package:src/infrastructure/service/pref_auth_methods_service.dart';
import 'package:src/data/model/pref_auth_methods_model.dart';
import 'package:src/data/model/put_pref_auth_methods_res_model.dart';

abstract class PrefauthMethodsRepository {
  Future<PrefauthMethodsModel> fetchPrefAuthMethods(int patientId);
  Future<PutPrefauthMethodsResModel> updatePrefauthMethods(int patientId, dynamic noteBody);
}

class PrefauthMethodsModelImpl extends PrefauthMethodsRepository {
  final PrefAuthMethodsService prefAuthMethodsService;

  PrefauthMethodsModelImpl(this.prefAuthMethodsService);

  @override
  Future<PrefauthMethodsModel> fetchPrefAuthMethods(int patientId) async {
    try {
      final request = await prefAuthMethodsService.fetchPrefAuthMethods(patientId);
      return request;
    } on DioException catch (e) {
      throw resposeDioException(e, '');
    }
  }

  @override
  Future<PutPrefauthMethodsResModel> updatePrefauthMethods(
      int patientId, dynamic putBody) async {
    try {
      final request =
          await prefAuthMethodsService.updatePrefauthMethods(patientId, putBody);
      return request;
    } on DioException catch (e) {
      throw resposeDioException(e, '');
    }
  }
}
