// To parse this JSON data, do
//
//     final prefauthMethodsModel = prefauthMethodsModelFromJson(jsonString);

import 'dart:convert';

PrefauthMethodsModel prefauthMethodsModelFromJson(String str) => PrefauthMethodsModel.fromJson(json.decode(str));

String prefauthMethodsModelToJson(PrefauthMethodsModel data) => json.encode(data.toJson());

class PrefauthMethodsModel {
    String? patientId;
    int? userId;
    EnabledMethods? enabledMethods;
    EnabledMethods? prefAuthMethodApp;

    PrefauthMethodsModel({
        this.patientId,
        this.userId,
        this.enabledMethods,
        this.prefAuthMethodApp,
    });

    factory PrefauthMethodsModel.fromJson(Map<String, dynamic> json) => PrefauthMethodsModel(
        patientId: json["patientId"],
        userId: json["userId"],
        enabledMethods: json["enabledMethods"] == null ? null : EnabledMethods.fromJson(json["enabledMethods"]),
        prefAuthMethodApp: json["prefAuthMethodApp"] == null ? null : EnabledMethods.fromJson(json["prefAuthMethodApp"]),
    );

    Map<String, dynamic> toJson() => {
        "patientId": patientId,
        "userId": userId,
        "enabledMethods": enabledMethods?.toJson(),
        "prefAuthMethodApp": prefAuthMethodApp?.toJson(),
    };
}

class EnabledMethods {
    bool? sms;
    bool? call;
    bool? email;
    bool? fingerprint;
    bool? authenticatorApp;

    EnabledMethods({
        this.sms,
        this.call,
        this.email,
        this.fingerprint,
        this.authenticatorApp,
    });

    factory EnabledMethods.fromJson(Map<String, dynamic> json) => EnabledMethods(
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
