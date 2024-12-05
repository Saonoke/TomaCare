import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tomacare/service/auth_service.dart';

class SaveAuth {
  final storage = FlutterSecureStorage();
  // final AuthService authService = AuthService();

  Future<void> storeToken(Map<String, dynamic> token) async {
    await storage.write(key: 'jwt_token', value: token['access_token']);
    await storage.write(key: 'refresh_token', value: token['refresh_token']);
  }

  Future<String?> getToken() async {
    final String? token = await storage.read(key: 'jwt_token');
    if (token != null) {
      bool hasExpired = JwtDecoder.isExpired(token);
      if (hasExpired) {
        final String? refresh_token = await storage.read(key: 'refresh_token');
        final updated_token = AuthService()
            .updateToken(refreshToken: refresh_token!, token: token);
        return updated_token;
      }
    }

    return token;
  }

  void deleteToken() async {
    return await storage.delete(key: 'jwt_token');
  }
}
