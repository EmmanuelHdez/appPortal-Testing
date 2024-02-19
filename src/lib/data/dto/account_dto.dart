class AccountDTO {
  PatientInfoDTO patientInfo;
  int upcomingAppointments;
  int pendingForms;
  int unreadNotes;

  AccountDTO({
    required this.patientInfo,
    required this.upcomingAppointments,
    required this.pendingForms,
    required this.unreadNotes,
  });
}

class PatientInfoDTO {
  int id;
  String fullName;
  String patientRef;
  String email;
  RecentPhotoDTO? recentPhoto;

  PatientInfoDTO({
    required this.id,
    required this.fullName,
    required this.patientRef,
    required this.email,
    this.recentPhoto,
  });
}

class RecentPhotoDTO {
  int? id;
  dynamic id_;
  String? name;
  String? url;
  String? key;

  RecentPhotoDTO({this.id, this.id_, this.name, this.url, this.key});
}
