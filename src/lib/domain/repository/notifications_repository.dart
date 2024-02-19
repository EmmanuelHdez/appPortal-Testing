import 'package:dio/dio.dart';
import 'package:src/errors/dioException.dart';
import 'package:src/infrastructure/service/notifications_service.dart';
import 'package:src/data/model/notifications_model.dart';

abstract class NotificationsRepository {
  Future<List<NotificationsModel>> fetchNotifications(int patientId);
  Future<NotificationSettingsModel> getNotificationSettings(int userId);
  Future<NotificationResponseModel> saveNotificationSettings(
      int userId, String notificationSetting);
  Future<dynamic> validateNotificationsScreen(int showSettingsValue);
}

class NotificationsRepositoryImpl extends NotificationsRepository {
  final NotificationsService notificationsService;

  NotificationsRepositoryImpl(this.notificationsService);

  @override
  Future<List<NotificationsModel>> fetchNotifications(int patientId) async {
    try {
      final request = await notificationsService.fetchNotifications(patientId);
      return request;
    } on DioException catch (e) {
      throw resposeDioException(e, '');
    }
  }

  @override
  Future<NotificationSettingsModel> getNotificationSettings(int userId) async {
    try {
      final request =
          await notificationsService.getNotificationSettings(userId);
      return request;
    } on DioException catch (e) {
      throw resposeDioException(e, '');
    }
  }

  @override
  Future<NotificationResponseModel> saveNotificationSettings(
      int userId, String notificationSetting) async {
    try {
      final request = await notificationsService.saveNotificationSettings(
          userId, notificationSetting);
      return request;
    } on DioException catch (e) {
      throw resposeDioException(e, '');
    }
  }

  @override
  Future<dynamic> validateNotificationsScreen(
      int showSettingsValue) async {
    try {
      final request = await notificationsService
          .validateNotificationsScreen(showSettingsValue);
      return request;
    } on DioException catch (e) {
      throw resposeDioException(e, '');
    }
  }
}
