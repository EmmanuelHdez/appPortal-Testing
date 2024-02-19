import 'package:src/data/model/pref_auth_methods_model.dart';
import 'package:src/domain/repository/pref_auth_methods_repository.dart';

class FetchPrefAuthMethodsUseCase {
  final PrefauthMethodsRepository prefAuthMethodsRepository;
  
  FetchPrefAuthMethodsUseCase(this.prefAuthMethodsRepository);
  Future<PrefauthMethodsModel> call({required int patientId}) async {
    return prefAuthMethodsRepository.fetchPrefAuthMethods(patientId);
  }
}
