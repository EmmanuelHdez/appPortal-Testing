import 'package:src/data/model/notifications_model.dart';
import 'package:src/domain/repository/notifications_repository.dart';

class GetNotificationSettingsUseCase {
  final NotificationsRepository notificationsRepository;

  GetNotificationSettingsUseCase(this.notificationsRepository);
  Future<NotificationSettingsModel> call({required int userId}) async {
    return notificationsRepository.getNotificationSettings(userId);
  }
}