// To parse this JSON data, do
//
//     final appointmentInfoModel = appointmentInfoModelFromJson(jsonString);

import 'dart:convert';

AppointmentInfoModel appointmentInfoModelFromJson(String str) => AppointmentInfoModel.fromJson(json.decode(str));

String appointmentInfoModelToJson(AppointmentInfoModel data) => json.encode(data.toJson());

class AppointmentInfoModel {
    int? id;
    DateTime? startTime;
    DateTime? endTime;
    bool? followUp;
    bool? f2F;
    bool? f2Ffollowup;
    bool? existingFollowup;
    String? patientLink;
    int? appointmentInfoModelDoctor;
    int? appointmentInfoModelTreatment;
    Doctor? doctor;
    Treatment? treatment;

    AppointmentInfoModel({
        this.id,
        this.startTime,
        this.endTime,
        this.followUp,
        this.f2F,
        this.f2Ffollowup,
        this.existingFollowup,
        this.patientLink,
        this.appointmentInfoModelDoctor,
        this.appointmentInfoModelTreatment,
        this.doctor,
        this.treatment,
    });

    factory AppointmentInfoModel.fromJson(Map<String, dynamic> json) => AppointmentInfoModel(
        id: json["id"],
        startTime: json["startTime"] == null ? null : DateTime.parse(json["startTime"]),
        endTime: json["endTime"] == null ? null : DateTime.parse(json["endTime"]),
        followUp: json["followUp"],
        f2F: json["f2f"],
        f2Ffollowup: json["f2ffollowup"],
        existingFollowup: json["existingFollowup"],
        patientLink: json["patientLink"],
        appointmentInfoModelDoctor: json["doctor"],
        appointmentInfoModelTreatment: json["treatment"],
        doctor: json["Doctor"] == null ? null : Doctor.fromJson(json["Doctor"]),
        treatment: json["Treatment"] == null ? null : Treatment.fromJson(json["Treatment"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "startTime": startTime?.toIso8601String(),
        "endTime": endTime?.toIso8601String(),
        "followUp": followUp,
        "f2f": f2F,
        "f2ffollowup": f2Ffollowup,
        "existingFollowup": existingFollowup,
        "patientLink": patientLink,
        "doctor": appointmentInfoModelDoctor,
        "treatment": appointmentInfoModelTreatment,
        "Doctor": doctor?.toJson(),
        "Treatment": treatment?.toJson(),
    };
}

class Doctor {
    int? id;
    String? firstName;
    String? lastName;

    Doctor({
        this.id,
        this.firstName,
        this.lastName,
    });

    factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
    };
}

class Treatment {
    int? id;
    String? name;

    Treatment({
        this.id,
        this.name,
    });

    factory Treatment.fromJson(Map<String, dynamic> json) => Treatment(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
