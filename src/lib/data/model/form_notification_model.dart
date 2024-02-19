import 'dart:convert';

FormNotification formNotificationFromJson(String str) => FormNotification.fromJson(json.decode(str));

String formNotificationToJson(FormNotification data) => json.encode(data.toJson());

class FormNotification {
    int? formId;
    String? formEditUrl;
    String? formType;
    String? formToken;
    String? formDateMessage;
    String? formTitle;
    String? formDescription;
    String? formViewUrl;
    int? locked;
    int? percentageCompletion;

    FormNotification({
        this.formId,
        this.formEditUrl,
        this.formType,
        this.formToken,
        this.formDateMessage,
        this.formTitle,
        this.formDescription,
        this.formViewUrl,
        this.locked,
        this.percentageCompletion,
    });

    factory FormNotification.fromJson(Map<String, dynamic> json) => FormNotification(
        formId: json["formID"],
        formEditUrl: json["formEditURL"],
        formType: json["formType"],
        formToken: json["formToken"],
        formDateMessage: json["formDateMessage"],
        formTitle: json["formTitle"],
        formDescription: json["formDescription"],
        formViewUrl: json["formViewURL"],
        locked: json["locked"],
        percentageCompletion: json["percentageCompletion"],
    );

    Map<String, dynamic> toJson() => {
        "formID": formId,
        "formEditURL": formEditUrl,
        "formType": formType,
        "formToken": formToken,
        "formDateMessage": formDateMessage,
        "formTitle": formTitle,
        "formDescription": formDescription,
        "formViewURL": formViewUrl,
        "locked": locked,
        "percentageCompletion": percentageCompletion,
    };
}