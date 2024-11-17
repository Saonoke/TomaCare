import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SaveAuth {
  final storage = FlutterSecureStorage();

  Future<void> storeToken(String token) async {
    await storage.write(key: 'jwt_token', value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  void deleteToken() async {
    return await storage.delete(key: 'jwt_token');
  }
}
