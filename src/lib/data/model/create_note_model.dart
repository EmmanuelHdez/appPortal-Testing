// To parse this JSON data, do
//
//     final createNoteModel = createNoteModelFromJson(jsonString);

import 'dart:convert';

CreateNoteModel createNoteModelFromJson(String str) => CreateNoteModel.fromJson(json.decode(str));

String createNoteModelToJson(CreateNoteModel data) => json.encode(data.toJson());

class CreateNoteModel {
    bool? notifyPatient;
    bool? dumpOne;
    bool? isDeleted;
    String? deletionReason;
    int? id;
    int? addedBy;
    String? noteSubject;
    String? noteType;
    String? notes;
    bool? privateNote;
    int? patient;
    String? created;

    CreateNoteModel({
        this.notifyPatient,
        this.dumpOne,
        this.isDeleted,
        this.deletionReason,
        this.id,
        this.addedBy,
        this.noteSubject,
        this.noteType,
        this.notes,
        this.privateNote,
        this.patient,
        this.created,
    });

    factory CreateNoteModel.fromJson(Map<String, dynamic> json) => CreateNoteModel(
        notifyPatient: json["notifyPatient"],
        dumpOne: json["dumpOne"],
        isDeleted: json["isDeleted"],
        deletionReason: json["deletionReason"],
        id: json["id"],
        addedBy: json["addedBy"],
        noteSubject: json["noteSubject"],
        noteType: json["noteType"],
        notes: json["notes"],
        privateNote: json["privateNote"],
        patient: json["patient"],
        created: json["created"],
    );

    Map<String, dynamic> toJson() => {
        "notifyPatient": notifyPatient,
        "dumpOne": dumpOne,
        "isDeleted": isDeleted,
        "deletionReason": deletionReason,
        "id": id,
        "addedBy": addedBy,
        "noteSubject": noteSubject,
        "noteType": noteType,
        "notes": notes,
        "privateNote": privateNote,
        "patient": patient,
        "created": created
    };
}
