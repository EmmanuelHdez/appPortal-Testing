import 'dart:convert';

import 'package:src/data/dto/user_dto.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));
String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel extends UserDTO {
  UserModel(
      {required this.userId,
      required this.token,
      required this.patientId,
      required this.firstName,
      required this.lastName})
      : super(
            userId: userId,
            token: token,
            patientId: patientId,
            firstName: firstName,
            lastName: lastName);

  String token;
  int userId;
  int patientId;
  String firstName;
  String lastName;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      token: json["token"], 
      userId: json["userId"], 
      patientId: json["patientId"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "userId": userId,
        "patientId": patientId,
        "firstName": firstName,
        "lastName": lastName
      };
}
