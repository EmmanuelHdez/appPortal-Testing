class NotificationsDTO {
  NotificationsDTO({
    required this.component,
    required this.count,
    this.doctor,
    this.startTime
  });

  String component;
  int count;
  DoctorDTO? doctor;
  String? startTime;
}

class DoctorDTO {
DoctorDTO({
  required this.title,
  required this.firstName,
  required this.lastName,
});
 String title;
 String  firstName;
 String  lastName;
}