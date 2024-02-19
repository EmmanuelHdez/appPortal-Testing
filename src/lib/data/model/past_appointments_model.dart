import 'dart:convert';

PastAppointmentsModel pastAppointmentsModelFromJson(String str) => PastAppointmentsModel.fromJson(json.decode(str));

String pastAppointmentsModelToJson(PastAppointmentsModel data) => json.encode(data.toJson());

class PastAppointmentsModel {
    int? total;
    int? limit;
    int? offset;
    List<Record>? records;

    PastAppointmentsModel({
        this.total,
        this.limit,
        this.offset,
        this.records,
    });

    factory PastAppointmentsModel.fromJson(Map<String, dynamic> json) => PastAppointmentsModel(
        total: json["total"],
        limit: json["limit"],
        offset: json["offset"],
        records: json["records"] == null ? [] : List<Record>.from(json["records"]!.map((x) => Record.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "limit": limit,
        "offset": offset,
        "records": records == null ? [] : List<dynamic>.from(records!.map((x) => x.toJson())),
    };
}

class Record {
    int? id;
    dynamic additionalMinutes;
    dynamic actualEndTime;
    bool? bookedViaForm;
    dynamic declineReason;
    int? recordDoctor;
    String? doctorMobileCode;
    String? doctorLink;
    String? endTime;
    bool? followUp;
    bool? f2F;
    bool? f2Ffollowup;
    bool? existingFollowup;
    bool? legacyDocument;
    String? notes;
    int? recordPatient;
    String? patientMobileCode;
    String? patientLink;
    bool? postConsultationForm;
    dynamic patientRating;
    String? status;
    String? startTime;
    dynamic timeCount;
    dynamic doctorFeedback;
    dynamic patientFeedback;
    int? recordInvoiceItem;
    dynamic mediaUrl;
    dynamic isTeamsMeeting;
    dynamic teamsMeetingStarted;
    Patient? patient;
    BookedBy? doctor;
    Treatment? treatment;
    InvoiceItem? invoiceItem;
    BookedBy? bookedBy;
    dynamic cancelledBy;

    Record({
        this.id,
        this.additionalMinutes,
        this.actualEndTime,
        this.bookedViaForm,
        this.declineReason,
        this.recordDoctor,
        this.doctorMobileCode,
        this.doctorLink,
        this.endTime,
        this.followUp,
        this.f2F,
        this.f2Ffollowup,
        this.existingFollowup,
        this.legacyDocument,
        this.notes,
        this.recordPatient,
        this.patientMobileCode,
        this.patientLink,
        this.postConsultationForm,
        this.patientRating,
        this.status,
        this.startTime,
        this.timeCount,
        this.doctorFeedback,
        this.patientFeedback,
        this.recordInvoiceItem,
        this.mediaUrl,
        this.isTeamsMeeting,
        this.teamsMeetingStarted,
        this.patient,
        this.doctor,
        this.treatment,
        this.invoiceItem,
        this.bookedBy,
        this.cancelledBy,
    });

    factory Record.fromJson(Map<String, dynamic> json) => Record(
        id: json["id"],
        additionalMinutes: json["additionalMinutes"],
        actualEndTime: json["actualEndTime"],
        bookedViaForm: json["bookedViaForm"],
        declineReason: json["declineReason"],
        recordDoctor: json["doctor"],
        doctorMobileCode: json["doctorMobileCode"],
        doctorLink: json["doctorLink"],
        endTime: json["endTime"],
        followUp: json["followUp"],
        f2F: json["f2f"],
        f2Ffollowup: json["f2ffollowup"],
        existingFollowup: json["existingFollowup"],
        legacyDocument: json["legacyDocument"],
        notes: json["notes"],
        recordPatient: json["patient"],
        patientMobileCode: json["patientMobileCode"],
        patientLink: json["patientLink"],
        postConsultationForm: json["postConsultationForm"],
        patientRating: json["patientRating"],
        status: json["status"],
        startTime: json["startTime"],
        timeCount: json["timeCount"],
        doctorFeedback: json["doctorFeedback"],
        patientFeedback: json["patientFeedback"],
        recordInvoiceItem: json["invoiceItem"],
        mediaUrl: json["mediaUrl"],
        isTeamsMeeting: json["isTeamsMeeting"],
        teamsMeetingStarted: json["teamsMeetingStarted"],
        patient: json["Patient"] == null ? null : Patient.fromJson(json["Patient"]),
        doctor: json["Doctor"] == null ? null : BookedBy.fromJson(json["Doctor"]),
        treatment: json["Treatment"] == null ? null : Treatment.fromJson(json["Treatment"]),
        invoiceItem: json["InvoiceItem"] == null ? null : InvoiceItem.fromJson(json["InvoiceItem"]),
        bookedBy: json["BookedBy"] == null ? null : BookedBy.fromJson(json["BookedBy"]),
        cancelledBy: json["CancelledBy"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "additionalMinutes": additionalMinutes,
        "actualEndTime": actualEndTime,
        "bookedViaForm": bookedViaForm,
        "declineReason": declineReason,
        "doctor": recordDoctor,
        "doctorMobileCode": doctorMobileCode,
        "doctorLink": doctorLink,
        "endTime": endTime,
        "followUp": followUp,
        "f2f": f2F,
        "f2ffollowup": f2Ffollowup,
        "existingFollowup": existingFollowup,
        "legacyDocument": legacyDocument,
        "notes": notes,
        "patient": recordPatient,
        "patientMobileCode": patientMobileCode,
        "patientLink": patientLink,
        "postConsultationForm": postConsultationForm,
        "patientRating": patientRating,
        "status": status,
        "startTime": startTime,
        "timeCount": timeCount,
        "doctorFeedback": doctorFeedback,
        "patientFeedback": patientFeedback,
        "invoiceItem": recordInvoiceItem,
        "mediaUrl": mediaUrl,
        "isTeamsMeeting": isTeamsMeeting,
        "teamsMeetingStarted": teamsMeetingStarted,
        "Patient": patient?.toJson(),
        "Doctor": doctor?.toJson(),
        "Treatment": treatment?.toJson(),
        "InvoiceItem": invoiceItem?.toJson(),
        "BookedBy": bookedBy?.toJson(),
        "CancelledBy": cancelledBy,
    };
}

class BookedBy {
    int? id;
    String? firstName;
    String? lastName;

    BookedBy({
        this.id,
        this.firstName,
        this.lastName,
    });

    factory BookedBy.fromJson(Map<String, dynamic> json) => BookedBy(
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

class InvoiceItem {
    int? id;
    int? invoiceItemInvoice;
    Invoice? invoice;

    InvoiceItem({
        this.id,
        this.invoiceItemInvoice,
        this.invoice,
    });

    factory InvoiceItem.fromJson(Map<String, dynamic> json) => InvoiceItem(
        id: json["id"],
        invoiceItemInvoice: json["invoice"],
        invoice: json["Invoice"] == null ? null : Invoice.fromJson(json["Invoice"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "invoice": invoiceItemInvoice,
        "Invoice": invoice?.toJson(),
    };
}

class Invoice {
    int? id;
    dynamic paypalId;
    bool? refunded;
    bool? paid;
    bool? closed;
    dynamic markPaidMethod;
    bool? cancelled;
    bool? emailSent;

    Invoice({
        this.id,
        this.paypalId,
        this.refunded,
        this.paid,
        this.closed,
        this.markPaidMethod,
        this.cancelled,
        this.emailSent,
    });

    factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        id: json["id"],
        paypalId: json["paypalId"],
        refunded: json["refunded"],
        paid: json["paid"],
        closed: json["closed"],
        markPaidMethod: json["markPaidMethod"],
        cancelled: json["cancelled"],
        emailSent: json["emailSent"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "paypalId": paypalId,
        "refunded": refunded,
        "paid": paid,
        "closed": closed,
        "markPaidMethod": markPaidMethod,
        "cancelled": cancelled,
        "emailSent": emailSent,
    };
}

class Patient {
    int? id;
    dynamic legacyId;
    int? patientNumber;
    String? firstName;
    String? lastName;
    int? patientClinic;
    bool? publishFeedback;
    Clinic? clinic;

    Patient({
        this.id,
        this.legacyId,
        this.patientNumber,
        this.firstName,
        this.lastName,
        this.patientClinic,
        this.publishFeedback,
        this.clinic,
    });

    factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        id: json["id"],
        legacyId: json["legacyId"],
        patientNumber: json["patientNumber"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        patientClinic: json["clinic"],
        publishFeedback: json["publishFeedback"],
        clinic: json["Clinic"] == null ? null : Clinic.fromJson(json["Clinic"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "legacyId": legacyId,
        "patientNumber": patientNumber,
        "firstName": firstName,
        "lastName": lastName,
        "clinic": patientClinic,
        "publishFeedback": publishFeedback,
        "Clinic": clinic?.toJson(),
    };
}

class Clinic {
    int? id;
    String? prefix;
    bool? private;
    dynamic commissioningGroup;

    Clinic({
        this.id,
        this.prefix,
        this.private,
        this.commissioningGroup,
    });

    factory Clinic.fromJson(Map<String, dynamic> json) => Clinic(
        id: json["id"],
        prefix: json["prefix"],
        private: json["private"],
        commissioningGroup: json["commissioningGroup"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "prefix": prefix,
        "private": private,
        "commissioningGroup": commissioningGroup,
    };
}

class Treatment {
    int? id;
    String? name;
    String? followupDuration;
    String? f2FDuration;
    String? f2FfollowupDuration;
    String? duration;
    Clinic? clinic;

    Treatment({
        this.id,
        this.name,
        this.followupDuration,
        this.f2FDuration,
        this.f2FfollowupDuration,
        this.duration,
        this.clinic,
    });

    factory Treatment.fromJson(Map<String, dynamic> json) => Treatment(
        id: json["id"],
        name: json["name"],
        followupDuration: json["followupDuration"],
        f2FDuration: json["f2fDuration"],
        f2FfollowupDuration: json["f2ffollowupDuration"],
        duration: json["duration"],
        clinic: json["Clinic"] == null ? null : Clinic.fromJson(json["Clinic"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "followupDuration": followupDuration,
        "f2fDuration": f2FDuration,
        "f2ffollowupDuration": f2FfollowupDuration,
        "duration": duration,
        "Clinic": clinic?.toJson(),
    };
}
