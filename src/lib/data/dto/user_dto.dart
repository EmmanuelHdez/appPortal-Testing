class UserDTO {
  UserDTO({
    required this.userId,
    required this.token,
    required this.patientId,
    required this.firstName,
    required this.lastName
  });

  String token;
  int userId;
  int patientId;
  String firstName;
  String lastName;
}
