import 'package:src/data/model/notifications_model.dart';
import 'package:src/domain/repository/notifications_repository.dart';

class SaveNotificationSettingsUseCase {
  final NotificationsRepository notificationsRepository;

  SaveNotificationSettingsUseCase(this.notificationsRepository);
  Future<NotificationResponseModel> call({
    required int userId,
    required String notificationSetting,
  }) async {
    return notificationsRepository.saveNotificationSettings(
        userId, notificationSetting);
  }
}
