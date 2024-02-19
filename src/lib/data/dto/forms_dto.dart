class FormsDTO {
    int? pendingFormCount;
    List<FormsRecordDTO>? pendingFormsRecords;
    int? completedFormsCount;
    List<FormsRecordDTO>? completedFormsRecords;

    FormsDTO({
         this.pendingFormCount,
         this.pendingFormsRecords,
        this.completedFormsCount,
        this.completedFormsRecords,
    });

}

class FormsRecordDTO {
    ResultDTO? result;

    FormsRecordDTO({
         this.result,
    });

}

class ResultDTO {
    int? id;
    int? patientId;
    String? formtypes;
    String? createdAt;
    String? updatedAt;
    String? formURLs;
    int? createdBy;
    PatientDTO? patient;

    ResultDTO({
         this.id,
         this.patientId,
         this.formtypes,
         this.createdAt,
         this.formURLs,
         this.createdBy,
         this.patient,
         this.updatedAt,
    });
}

class PatientDTO {
    int? id;
    String? firstName;
    String? lastName;

    PatientDTO({
         this.id,
         this.firstName,
         this.lastName,
    });

}
