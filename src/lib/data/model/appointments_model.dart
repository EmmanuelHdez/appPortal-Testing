// To parse this JSON data, do
//
//     final appointmentsModel = appointmentsModelFromJson(jsonString);

import 'dart:convert';

AppointmentsModel appointmentsModelFromJson(String str) => AppointmentsModel.fromJson(json.decode(str));

String appointmentsModelToJson(AppointmentsModel data) => json.encode(data.toJson());

class AppointmentsModel {
    int? total;
    int? limit;
    int? offset;
    List<AppointmentModel>? records;

    AppointmentsModel({
        this.total,
        this.limit,
        this.offset,
        this.records,
    });

    factory AppointmentsModel.fromJson(Map<String, dynamic> json) => AppointmentsModel(
        total: json["total"],
        limit: json["limit"],
        offset: json["offset"],
        records: json["records"] == null ? [] : List<AppointmentModel>.from(json["records"]!.map((x) => AppointmentModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "limit": limit,
        "offset": offset,
        "records": records == null ? [] : List<dynamic>.from(records!.map((x) => x.toJson())),
    };
}

class AppointmentModel {
    int? id;
    int? recordPatient;
    int? recordDoctor;
    int? treatment;
    bool? followUp;
    bool? f2F;
    bool? f2Ffollowup;
    bool? existingFollowup;
    String? startTime;
    String? endTime;
    String? status;
    Doctor? patient;
    Doctor? doctor;

    AppointmentModel({
        this.id,
        this.recordPatient,
        this.recordDoctor,
        this.treatment,
        this.followUp,
        this.f2F,
        this.f2Ffollowup,
        this.existingFollowup,
        this.startTime,
        this.endTime,
        this.status,
        this.patient,
        this.doctor,
    });

    factory AppointmentModel.fromJson(Map<String, dynamic> json) => AppointmentModel(
        id: json["id"],
        recordPatient: json["patient"],
        recordDoctor: json["doctor"],
        treatment: json["treatment"],
        followUp: json["followUp"],
        f2F: json["f2f"],
        f2Ffollowup: json["f2ffollowup"],
        existingFollowup: json["existingFollowup"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        status: json["status"],
        patient: json["Patient"] == null ? null : Doctor.fromJson(json["Patient"]),
        doctor: json["Doctor"] == null ? null : Doctor.fromJson(json["Doctor"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "patient": recordPatient,
        "doctor": recordDoctor,
        "treatment": treatment,
        "followUp": followUp,
        "f2f": f2F,
        "f2ffollowup": f2Ffollowup,
        "existingFollowup": existingFollowup,
        "startTime": startTime,
        "endTime": endTime,
        "status": status,
        "Patient": patient?.toJson(),
        "Doctor": doctor?.toJson(),
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
