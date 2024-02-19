class TokenB2cModel {
  final int patientId;
  final int userId;
  final String? lastName;
  final String? firstName;
  final String? prefFirstName;
  final String? prefMiddleName;
  final String? prefLastName;
  final String? token;
  final String? patientMobile;
  final String email;
  final String password;
  final bool? authenticationApp;
  final bool? showMySettingsApp;
  final bool? prefAuthMethodsSaved;
  final String? authMethods;
  final bool? fingerprintAuth;

  TokenB2cModel({
     required this.patientId, 
      required this.userId,
      required this.email, 
      required this.password,
    this.lastName, 
    this.firstName, 
    this.prefFirstName, 
    this.prefMiddleName, 
    this.prefLastName, 
    this.token, 
    this.authenticationApp,
    this.patientMobile,    
    this.showMySettingsApp,
    this.prefAuthMethodsSaved,
    this.authMethods,
    this.fingerprintAuth,
    });
}
