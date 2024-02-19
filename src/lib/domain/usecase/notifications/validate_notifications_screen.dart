import 'package:src/domain/repository/notifications_repository.dart';

class ValidateNotificationSettingsScreenUseCase {
  final NotificationsRepository notificationsRepository;

  ValidateNotificationSettingsScreenUseCase(this.notificationsRepository);
  Future<dynamic> call({required int showSettingsValue}) async {
    return notificationsRepository
        .validateNotificationsScreen(showSettingsValue);
  }
}
