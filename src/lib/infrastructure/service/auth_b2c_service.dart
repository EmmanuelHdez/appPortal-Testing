import 'package:jwt_decode/jwt_decode.dart';
import 'package:src/data/model/token_b2c_model.dart';
class AzureADb2cService {
  TokenB2cModel decodeToken(String token) {
    Map<String, dynamic>? decodedToken = Jwt.parseJwt(token);
    // ignore: unnecessary_null_comparison
    if (decodedToken != null) {
      // Accessing the token information
      int patientId = decodedToken['patientId'];
      int userId = decodedToken['userId'];
      String? firstName = decodedToken['firstName'];
      String? lastName = decodedToken['lastName'];
      String? prefFirstName = decodedToken['prefFirstName'];
      String? prefMiddleName = decodedToken['prefMiddleName'];
      String? prefLastName = decodedToken['prefLastName'];
      String? token = decodedToken['token'];
      String? patientMobile = decodedToken['patientMobile'];
      String email = decodedToken['email'];
      String password = decodedToken['readOnlyPassword'];
      bool? authenticationApp = decodedToken['authenticationApp'];
      bool? showMySettingsApp = decodedToken['showMySettingsApp'];
      bool? prefAuthMethodsSaved = decodedToken['prefAuthMethodsSaved'];
      String? authMethods = decodedToken['authMethods'];
      bool? fingerprintAuth = decodedToken['fingerprintAuth'];

      return TokenB2cModel(
        patientId: patientId,
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        prefFirstName: prefFirstName,
        prefMiddleName: prefMiddleName,
        prefLastName: prefLastName,
        email: email,
        patientMobile: patientMobile,
        authenticationApp: authenticationApp,
        password: password,
        token: token,
        showMySettingsApp: showMySettingsApp,
        prefAuthMethodsSaved: prefAuthMethodsSaved,
        authMethods: authMethods,
        fingerprintAuth: fingerprintAuth
      );
    } else {
      return TokenB2cModel(
        patientId: 0,
        userId: 0,
        email: "",
        password: "",
      );
    }
  }
}
