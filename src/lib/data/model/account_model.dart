import 'dart:convert';
import 'package:src/data/dto/account_dto.dart';

AccountModel accountModelFromJson(String str) =>
    AccountModel.fromJson(json.decode(str));

String accountModelToJson(AccountModel data) => json.encode(data.toJson());

class AccountModel extends AccountDTO {
  final PatientInfoModel patientInfo;
  final int upcomingAppointments;
  final int pendingForms;
  final int unreadNotes;

  AccountModel({
    required this.patientInfo,
    required this.upcomingAppointments,
    required this.pendingForms,
    required this.unreadNotes,
  }) : super(
            patientInfo: patientInfo,
            upcomingAppointments: upcomingAppointments,
            pendingForms: pendingForms,
            unreadNotes: unreadNotes);

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
        patientInfo: PatientInfoModel.fromJson(json["patientInfo"]),
        upcomingAppointments: json["upcomingAppointments"],
        pendingForms: json["pendingForms"],
        unreadNotes: json["unreadNotes"],
      );

  Map<String, dynamic> toJson() => {
        "patientInfo": patientInfo.toJson(),
        "upcomingAppointments": upcomingAppointments,
        "pendingForms": pendingForms,
        "unreadNotes": unreadNotes,
      };
}

class PatientInfoModel extends PatientInfoDTO {
  final int id;
  final String fullName;
  final String patientRef;
  final String email;
  final RecentPhotoModel? recentPhoto;

  PatientInfoModel({
    required this.id,
    required this.fullName,
    required this.patientRef,
    required this.email,
     this.recentPhoto,
  }) : super(
            id: id,
            fullName: fullName,
            patientRef: patientRef,
            email: email,
            recentPhoto: recentPhoto);

  factory PatientInfoModel.fromJson(Map<String, dynamic> json) =>
      PatientInfoModel(
        id: json["id"],
        fullName: json["fullName"],
        patientRef: json["patientRef"],
        email: json["email"],
        recentPhoto: json["recentPhoto"] == null ? null : RecentPhotoModel.fromJson(json["recentPhoto"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "patientRef": patientRef,
        "email": email,
        // ignore: prefer_null_aware_operators
        "recentPhoto": recentPhoto == null ? null : recentPhoto?.toJson(),
      };
}

class RecentPhotoModel extends RecentPhotoDTO {
  int? id;
  dynamic id_;
  String? name;
  String? url;
  String? key;

    RecentPhotoModel({
         this.id,
         this.id_,
         this.name,
         this.url,
         this.key,
    }): super(id: id, id_: id, name: name, url: url, key: key);

    factory RecentPhotoModel.fromJson(Map<String, dynamic> json) => RecentPhotoModel(
        id: json["id"],
        id_: json["_id"],
        name: json["name"],
        url: json["url"],
        key: json["key"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "_id": id_,
        "name": name,
        "url": url,
        "key": key,
    };
}