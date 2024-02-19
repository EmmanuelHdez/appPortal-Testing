// To parse this JSON data, do
import 'dart:convert';

import 'package:src/data/dto/forms_dto.dart';

FormsModel formsModelFromJson(String str) => FormsModel.fromJson(json.decode(str));

String formsToJson(FormsModel data) => json.encode(data.toJson());

class FormsModel extends FormsDTO {
  int? pendingFormCount;
  final List<FormsRecordModel>? pendingFormsRecords;
  int? completedFormsCount;
  final List<FormsRecordModel>? completedFormsRecords;

  List<FormsRecordModel>? allFormsRecordsAux;
  List<FormsRecordModel>? allFormsRecords;

  FormsModel({
    this.pendingFormCount,
    this.pendingFormsRecords,
    this.completedFormsCount,
    this.completedFormsRecords,
  }) : super(
            pendingFormCount: pendingFormCount,
            pendingFormsRecords: pendingFormsRecords,
            completedFormsCount: completedFormsCount,
            completedFormsRecords: completedFormsRecords) {
    Set<int> uniqueIds = Set<int>();
    allFormsRecords = [];
    allFormsRecordsAux = []
      ..addAll(pendingFormsRecords ?? [])
      ..addAll(completedFormsRecords ?? [])
      ..sort((a, b) {
        final dateA = a.result?.createdAt ?? "";
        final dateB = b.result?.createdAt ?? "";
        return dateB.compareTo(dateA);
      });

      allFormsRecordsAux?.forEach((collection) {
        bool allowToPush = true;
        allFormsRecords?.forEach((element) {
          if(collection.result?.id == element?.result?.id){
            allowToPush = false;
          }
        });
        if(allowToPush == true) allFormsRecords?.add(collection);
      });
  }



  factory FormsModel.fromJson(Map<String, dynamic> json) => FormsModel(
        pendingFormCount: json["pendingFormCount"],
        pendingFormsRecords: json["pendingFormsRecords"] == null
            ? []
            : List<FormsRecordModel>.from(json["pendingFormsRecords"]
                .map((x) => FormsRecordModel.fromJson(x))),
        completedFormsCount: json["completedFormsCount"],
        completedFormsRecords: json["completedFormsRecords"] == null
            ? []
            : List<FormsRecordModel>.from(json["completedFormsRecords"]
                .map((x) => FormsRecordModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
        "pendingFormCount": pendingFormCount,
        "pendingFormsRecords": pendingFormsRecords == null ? [] :
            List<dynamic>.from(pendingFormsRecords!.map((x) => x.toJson())),
        "completedFormsCount": completedFormsCount,
        "completedFormsRecords":completedFormsRecords == null ? [] :
            List<dynamic>.from(completedFormsRecords!.map((x) => x.toJson())),
        "allFormsRecords": allFormsRecords == null
            ? []
            : List<dynamic>.from(allFormsRecords!.map((x) => x.toJson())),
      };
}

class FormsRecordModel extends FormsRecordDTO {
  final ResultModel? result;

  FormsRecordModel({
     this.result,
  }) : super(result: result);

  factory FormsRecordModel.fromJson(Map<String, dynamic> json) =>
      FormsRecordModel(
        result: json["result"] == null ? null : ResultModel.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result?.toJson(),
      };
}

class ResultModel extends ResultDTO {
  int? id;
  int? patientId;
  String? formtypes;
  String? createdAt;
  String? updatedAt;
  String? formURLs;
  int? createdBy;
  final PatientModel? patient;

  ResultModel({
     this.id,
     this.patientId,
     this.formtypes,
     this.createdAt,
     this.updatedAt,
     this.formURLs,
     this.createdBy,
     this.patient,
  }) : super(
            id: id,
            patientId: patientId,
            formtypes: formtypes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            formURLs: formURLs,
            createdBy: 0,
            patient: patient);

  factory ResultModel.fromJson(Map<String, dynamic> json) => ResultModel(
        id: json["id"],
        patientId: json["patient"],
        formtypes: json["formtypes"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        formURLs: json["formURLs"],
        createdBy: json["createdBy"],
        patient: json["Patient"] == null ? null : PatientModel.fromJson(json["Patient"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "patient": patientId,
        "formtypes": formtypes,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "formURLs": formURLs,
        "createdBy": createdBy,
        "Patient": patient?.toJson(),
      };
}

class PatientModel extends PatientDTO {
  int? id;
  String? firstName;
  String? lastName;

  PatientModel({
     this.id,
     this.firstName,
     this.lastName,
  }) : super(id: id, firstName: firstName, lastName: lastName);

  factory PatientModel.fromJson(Map<String, dynamic> json) => PatientModel(
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
