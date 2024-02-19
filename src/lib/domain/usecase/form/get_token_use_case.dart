import 'package:src/data/model/notifications_model.dart';
import 'package:src/domain/repository/forms_repository.dart';

class GetTokenUseCase {
  final FormsRepository formsRepository;

  GetTokenUseCase(this.formsRepository);
  Future<FormCollectionsTokenModel> call(
      {required int collectionId,
      required int patientId,
      required int userId,
      required bool isDoctor}) async {
    return formsRepository.getToken(collectionId, patientId, userId, isDoctor);
  }
}
