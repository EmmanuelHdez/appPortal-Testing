import 'package:src/data/model/account_model.dart';
import 'package:src/domain/repository/account_repository.dart';

class AccountUseCase {
  final AccountRepository accountRepository;

  AccountUseCase(this.accountRepository);
  Future<AccountModel> call({required int patientId}) async {
    return accountRepository.fetchPatient(patientId);
  }
}
