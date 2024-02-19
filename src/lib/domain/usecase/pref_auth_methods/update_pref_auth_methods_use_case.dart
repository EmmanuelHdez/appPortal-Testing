import 'package:src/data/model/put_pref_auth_methods_res_model.dart';
import 'package:src/domain/repository/pref_auth_methods_repository.dart';

class UpdatePrefAuthMethodsUseCase {
  final PrefauthMethodsRepository prefauthMethodsRepository;

  UpdatePrefAuthMethodsUseCase(this.prefauthMethodsRepository);
  Future<PutPrefauthMethodsResModel> call(
      {required int patientId,
      required dynamic putBody}) async {
    return prefauthMethodsRepository.updatePrefauthMethods(patientId, putBody);
  }
}
