
import 'package:src/data/model/notifications_model.dart';
import 'package:src/domain/repository/notifications_repository.dart';

class NotificationsUseCase {
  final NotificationsRepository notificationsRepository;

  NotificationsUseCase(this.notificationsRepository);
  Future<List<NotificationsModel>> call({required int patientId}) async {
    return notificationsRepository.fetchNotifications(patientId);
  }
}
