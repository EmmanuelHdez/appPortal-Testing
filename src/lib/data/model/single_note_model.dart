// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

NoteModel noteModelFromJson(String str) => NoteModel.fromJson(json.decode(str));

String noteToJson(NoteModel data) => json.encode(data.toJson());

class NoteModel {
    int? id;
    DateTime? created;
    String? noteType;
    bool? privateNote;
    String? noteSubject;
    String? notes;
    dynamic legacyCustomerId;
    dynamic legacyId;
    dynamic seenAt;
    dynamic notesHtml;
    dynamic notesJson;
    dynamic sopCodes;
    dynamic sopCodesHistory;
    List<dynamic>? comments;
    List<dynamic>? attachments;
    AddedBy? addedBy;
    dynamic seenBy;
    List<dynamic>? formCollections;
    Task? task;

    NoteModel({
        this.id,
        this.created,
        this.noteType,
        this.privateNote,
        this.noteSubject,
        this.notes,
        this.legacyCustomerId,
        this.legacyId,
        this.seenAt,
        this.notesHtml,
        this.notesJson,
        this.sopCodes,
        this.sopCodesHistory,
        this.comments,
        this.attachments,
        this.addedBy,
        this.seenBy,
        this.formCollections,
        this.task,
    });

    factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
        id: json["id"],
        created: json["created"] == null ? null : DateTime.parse(json["created"]),
        noteType: json["noteType"],
        privateNote: json["privateNote"],
        noteSubject: json["noteSubject"],
        notes: json["notes"],
        legacyCustomerId: json["legacyCustomerId"],
        legacyId: json["legacyId"],
        seenAt: json["seenAt"],
        notesHtml: json["notesHTML"],
        notesJson: json["notesJSON"],
        sopCodes: json["sopCodes"],
        sopCodesHistory: json["sopCodesHistory"],
        comments: json["comments"] == null ? [] : List<dynamic>.from(json["comments"]!.map((x) => x)),
        attachments: json["attachments"] == null ? [] : List<dynamic>.from(json["attachments"]!.map((x) => x)),
        addedBy: json["AddedBy"] == null ? null : AddedBy.fromJson(json["AddedBy"]),
        seenBy: json["SeenBy"],
        formCollections: json["FormCollections"] == null ? [] : List<dynamic>.from(json["FormCollections"]!.map((x) => x)),
        task: json["Task"] == null ? null : Task.fromJson(json["Task"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "created": created?.toIso8601String(),
        "noteType": noteType,
        "privateNote": privateNote,
        "noteSubject": noteSubject,
        "notes": notes,
        "legacyCustomerId": legacyCustomerId,
        "legacyId": legacyId,
        "seenAt": seenAt,
        "notesHTML": notesHtml,
        "notesJSON": notesJson,
        "sopCodes": sopCodes,
        "sopCodesHistory": sopCodesHistory,
        "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x)),
        "attachments": attachments == null ? [] : List<dynamic>.from(attachments!.map((x) => x)),
        "AddedBy": addedBy?.toJson(),
        "SeenBy": seenBy,
        "FormCollections": formCollections == null ? [] : List<dynamic>.from(formCollections!.map((x) => x)),
        "Task": task?.toJson(),
    };
}

class AddedBy {
    int? id;
    String? firstName;
    String? lastName;
    dynamic azureObjectId;
    dynamic jobTitle;
    dynamic department;

    AddedBy({
        this.id,
        this.firstName,
        this.lastName,
        this.azureObjectId,
        this.jobTitle,
        this.department,
    });

    factory AddedBy.fromJson(Map<String, dynamic> json) => AddedBy(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        azureObjectId: json["azureObjectId"],
        jobTitle: json["jobTitle"],
        department: json["department"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "azureObjectId": azureObjectId,
        "jobTitle": jobTitle,
        "department": department,
    };
}

class Task {
    int? id;
    int? taskAssignedUser;
    int? note;
    AssignedUser? assignedUser;

    Task({
        this.id,
        this.taskAssignedUser,
        this.note,
        this.assignedUser,
    });

    factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        taskAssignedUser: json["assignedUser"],
        note: json["note"],
        assignedUser: json["AssignedUser"] == null ? null : AssignedUser.fromJson(json["AssignedUser"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "assignedUser": taskAssignedUser,
        "note": note,
        "AssignedUser": assignedUser?.toJson(),
    };
}

class AssignedUser {
    int? id;
    String? firstName;
    String? lastName;

    AssignedUser({
        this.id,
        this.firstName,
        this.lastName,
    });

    factory AssignedUser.fromJson(Map<String, dynamic> json) => AssignedUser(
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
