import 'package:src/config/config.dart';
import 'package:src/shared/shared_preferences.dart';

class UserPreferences {
  void saveEmailUser(String? email) {
    MySharedPreferences.instance.setStringValue(USER_EMAIL, email!);
  }

  void saveAzureB2CToken(token) {
    MySharedPreferences.instance.setStringValue(AZURE_TOKEN_KEY, token);
  }

  void saveToken(token) {
    MySharedPreferences.instance.setStringValue(TOKEN_KEY, token);
  }

  void saveUserId(id) {
    MySharedPreferences.instance.setIntValue(USER_ID, id);
  }

  void saveStringValues(key, value) {
    MySharedPreferences.instance.setStringValue(key, value);
  }

  void savePatientId(id) {
    MySharedPreferences.instance.setIntValue(PATIENT_ID, id);
  }

  void saveFingerprintEnabled (bool enabled) {
    MySharedPreferences.instance.setBoolValue(FINGERPRINT_ENABLED, enabled);
  }

  void saveFingerprintFirstLogin (bool enabled) {
    MySharedPreferences.instance.setBoolValue(FINGERPRINT_NOFIRSTLOGIN, enabled);
  }

  void saveFingerprintCompatible (bool enabled) {
    MySharedPreferences.instance.setBoolValue(FINGERPRINT_COMPATIBLE, enabled);
  }


  void saveShowSettingsValue(value) {
    int showModal = value == true ? 1 : 0;
    MySharedPreferences.instance
        .setIntValue(SHOW_CONFIG_SETTINGS_MODAL, showModal);
  }

  void removeCurrentUser() {
    MySharedPreferences.instance.removeValue(USER_NAME);
    MySharedPreferences.instance.removeValue(USER_FIRSTNAME);
    MySharedPreferences.instance.removeValue(USER_LASTNAME);
    MySharedPreferences.instance.removeValue(USER_PREF_FIRSTNAME);
    MySharedPreferences.instance.removeValue(USER_PREF_MIDDLENAME);
    MySharedPreferences.instance.removeValue(USER_PREF_LASTNAME);
    MySharedPreferences.instance.removeValue(USER_ID);
    MySharedPreferences.instance.removeValue(PATIENT_ID);
    MySharedPreferences.instance.removeValue(USER_EMAIL);
    MySharedPreferences.instance.removeValue(TOKEN_KEY);
    MySharedPreferences.instance.removeValue(AZURE_TOKEN_KEY);
    MySharedPreferences.instance.removeValue(SHOW_CONFIG_SETTINGS_MODAL);
    MySharedPreferences.instance.removeValue(PREF_AUTH_METHODS_SAVED);
    MySharedPreferences.instance.removeValue(FINGERPRINT_ENABLED);
  }

  void removePortalToken() {
    MySharedPreferences.instance.removeValue(TOKEN_KEY);
  }
  Future<String> getDeviceIP() {
    return MySharedPreferences.instance.getStringValue(DEVICE_PUBLIC_IP);
  }

  Future<String> getDeviceOS() {
    return MySharedPreferences.instance.getStringValue(DEVICE_OS);
  }

  Future<String> getToken() {
    return MySharedPreferences.instance.getStringValue(TOKEN_KEY);
  }

  Future<bool> getFingerprintEnabled() {
    return MySharedPreferences.instance.getBoolValue(FINGERPRINT_ENABLED);
  }

  Future<bool> getFingerprintFirstLogin() {
    return MySharedPreferences.instance.getBoolValue(FINGERPRINT_NOFIRSTLOGIN);
  }

  Future<bool> getFingerprintCompatible() {
    return MySharedPreferences.instance.getBoolValue(FINGERPRINT_COMPATIBLE);
  }

  Future<String> getAzureToken() async {
    return await MySharedPreferences.instance.getStringValue(AZURE_TOKEN_KEY);
  }

  Future<int> getPatientId() async {
    return await MySharedPreferences.instance.getIntValue(PATIENT_ID);
  }

  Future<int> getUserId() async {
    return await MySharedPreferences.instance.getIntValue(USER_ID);
  }
}
