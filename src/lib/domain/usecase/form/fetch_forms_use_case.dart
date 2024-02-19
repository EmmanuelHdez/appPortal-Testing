import 'package:src/data/model/forms_model.dart';
import 'package:src/domain/repository/forms_repository.dart';

class FetchFormsUseCase {
  final FormsRepository formsRepository;
  
  FetchFormsUseCase(this.formsRepository);
  Future<FormsModel> call({required int patientId}) async {
    return formsRepository.fetchForms(patientId);
  }
}
