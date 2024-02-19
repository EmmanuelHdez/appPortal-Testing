// To parse this JSON data, do
//
//     final putPrefauthMethodsResModel = putPrefauthMethodsResModelFromJson(jsonString);

import 'dart:convert';

PutPrefauthMethodsResModel putPrefauthMethodsResModelFromJson(String str) => PutPrefauthMethodsResModel.fromJson(json.decode(str));

String putPrefauthMethodsResModelToJson(PutPrefauthMethodsResModel data) => json.encode(data.toJson());

class PutPrefauthMethodsResModel {
    String? status;
    int? success;
    int? userUpdated;
    NewData? newData;

    PutPrefauthMethodsResModel({
        this.status,
        this.success,
        this.userUpdated,
        this.newData,
    });

    factory PutPrefauthMethodsResModel.fromJson(Map<String, dynamic> json) => PutPrefauthMethodsResModel(
        status: json["status"],
        success: json["success"],
        userUpdated: json["userUpdated"],
        newData: json["newData"] == null ? null : NewData.fromJson(json["newData"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "success": success,
        "userUpdated": userUpdated,
        "newData": newData?.toJson(),
    };
}

class NewData {
    bool? sms;
    bool? call;
    bool? email;
    bool? fingerprint;
    bool? authenticatorApp;

    NewData({
        this.sms,
        this.call,
        this.email,
        this.fingerprint,
        this.authenticatorApp,
    });

    factory NewData.fromJson(Map<String, dynamic> json) => NewData(
        sms: json["sms"],
        call: json["call"],
        email: json["email"],
        fingerprint: json["fingerprint"],
        authenticatorApp: json["authenticatorApp"],
    );

    Map<String, dynamic> toJson() => {
        "sms": sms,
        "call": call,
        "email": email,
        "fingerprint": fingerprint,
        "authenticatorApp": authenticatorApp,
    };
}
