import 'package:dio/dio.dart';
import 'package:src/data/model/account_model.dart';
import 'package:src/errors/dioException.dart';
import 'package:src/infrastructure/service/acount_service.dart';

abstract class AccountRepository {
  Future<AccountModel> fetchPatient(int patientId);
}

class AccountRepositoryImpl extends AccountRepository {
  final AccountService accountService;

  AccountRepositoryImpl(this.accountService);

  @override
  Future<AccountModel> fetchPatient(int patientId) async {
    try {
      final request = await accountService.fetchPatient(patientId);
      return request;
    } on DioException catch (e) {
      throw resposeDioException(e, '');
    }
  }
}
