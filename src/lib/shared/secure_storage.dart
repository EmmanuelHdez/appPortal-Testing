import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  writeSecureData(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  readAllSecureData() async {
    Map<String, String> allValues = await storage.readAll();
    return allValues;
  }

  readSecureData(String key) async {
    String value = await storage.read(key: key) ?? 'No data found!';
    return value;
  }

  deleteSecureData(String key) async {
    await storage.delete(key: key);
  }  

  removeAll() async {
    await storage.deleteAll();
  }
}

class UserCredentials {
  void saveEmailUser(String email) {
    SecureStorage().writeSecureData("email", email);
  }

  void savePasswordUser(String password) {
    SecureStorage().writeSecureData("password", password);
  }

  void removeUserCredentials() {
    SecureStorage().removeAll();
  }    

  Future<String> getUserEmail() async {
    return await SecureStorage().readSecureData("email");
  }
  Future<String> getUserPassword() async {
    return await SecureStorage().readSecureData("password");
  }

  Future<Map<String, String>> getUserCrendentials() async {
    return await SecureStorage().readAllSecureData();
  }

  
}




