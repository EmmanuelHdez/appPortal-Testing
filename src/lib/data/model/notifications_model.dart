import 'dart:convert';

import 'package:src/data/dto/notifications_dto.dart';

List<NotificationsModel> notificationsModelFromJson(String str) =>
    List<NotificationsModel>.from(
        json.decode(str).map((x) => NotificationsModel.fromJson(x)));

String notificationModelToJson(List<NotificationsModel> data) =>
    json.encode(List<dynamic>.from(data.map((e) => e.toJson())));

class NotificationsModel extends NotificationsDTO {
  NotificationsModel(
      {required this.component,
      required this.count,
      this.doctor,
      this.startTime})
      : super(
            component: component,
            count: count,
            doctor: doctor,
            startTime: startTime);
  final String component;
  final int count;
  final DoctorModel? doctor;
  final String? startTime;

  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      NotificationsModel(
        component: json["component"],
        count: json["count"],
        doctor: json['doctor'] != null
            ? DoctorModel.fromJson(json['doctor'])
            : null,
        startTime: json["startTime"],
      );

  Map<String, dynamic> toJson() => {
        "component": component,
        "count": count,
        "doctor": doctor!.toJson(),
        "startTime": startTime
      };
}

class DoctorModel extends DoctorDTO {
  DoctorModel({
    required this.title,
    required this.firstName,
    required this.lastName,
  }) : super(title: title, firstName: firstName, lastName: lastName);

  final String title;
  final String firstName;
  final String lastName;

  factory DoctorModel.fromJson(Map<String, dynamic> json) => DoctorModel(
      title: json['title'],
      firstName: json['firstName'],
      lastName: json['lastName']);

  Map<String, dynamic> toJson() => {
        "title": title,
        "firstName": firstName,
        "lastName": lastName,
      };
}

FormCollectionsTokenModel formCollectionsTokenModelFromJson(String str) =>
    FormCollectionsTokenModel.fromJson(json.decode(str));
String formCollectionsTokenModelToJson(FormCollectionsTokenModel data) =>
    json.encode(data.toJson());

class FormCollectionsTokenModel {
  String token;

  FormCollectionsTokenModel({
    required this.token,
  });

  factory FormCollectionsTokenModel.fromJson(Map<String, dynamic> json) =>
      FormCollectionsTokenModel(
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
      };
}

NotificationSettingsModel notificationSettingsModelFromJson(String str) =>
    NotificationSettingsModel.fromJson(json.decode(str));

String notificationSettingsModelToJson(NotificationSettingsModel data) =>
    json.encode(data.toJson());

class NotificationSettingsModel {
  dynamic notificationSetting;

  NotificationSettingsModel({
    this.notificationSetting,
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) =>
      NotificationSettingsModel(
        notificationSetting: json["notificationSetting"],
      );

  Map<String, dynamic> toJson() => {
        "notificationSetting": notificationSetting,
      };
}

NotificationResponseModel notificationResponseModelFromJson(String str) =>
    NotificationResponseModel.fromJson(json.decode(str));

String notificationResponseModelToJson(NotificationResponseModel data) =>
    json.encode(data.toJson());

class NotificationResponseModel {
  bool? success;

  NotificationResponseModel({
    this.success,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) =>
      NotificationResponseModel(
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
      };
}
