import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tomacare/presentation/misc/constant/app_constant.dart';
import 'package:tomacare/service/save_auth.dart';

class AuthService {
  final SaveAuth saveAuth = SaveAuth();
  Future<Map<String, dynamic>> login(
      {required String emailOrUsername, required String password}) async {
    final url = Uri.parse('$baseurl/auth/token');

    final response = await http.post(url,
        headers: headers,
        body: jsonEncode(
            {'email_or_username': emailOrUsername, 'password': password}));

    if (response.statusCode == HttpStatus.ok) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body));
    }
  }

  Future<Map<String, dynamic>> register(
      {required String email,
      required String fullname,
      required String username,
      required String password}) async {
    final url = Uri.parse('$baseurl/auth');
    final response = await http.post(url,
        headers: headers,
        body: jsonEncode({
          'email': email,
          'full_name': fullname,
          'username': username,
          'password': password
        }));

    if (response.statusCode == HttpStatus.created) {
      Map<String, dynamic> data = jsonDecode(response.body);
      data['password'] = password;
      return data;
    } else {
      throw Exception(jsonDecode(response.body)['detail']);
    }
  }

  Future<Map<String, dynamic>> googleLogin(
      {required String googleAccessToken}) async {
    final url = Uri.parse('$baseurl/auth/google');

    final response = await http.post(url,
        headers: headers,
        body: jsonEncode({'google_access_token': googleAccessToken}));

    if (response.statusCode == HttpStatus.ok) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['detail']);
    }
  }

  Future<String?> updateToken(
      {required String refreshToken, required String token}) async {
    final url = Uri.parse('$baseurl/auth/refresh');
    headers.addAll({'Authorization': 'Bearer $token'});
    final response = await http.post(url,
        headers: headers, body: jsonEncode({'refresh_token': refreshToken}));
    if (response.statusCode == 200) {
      saveAuth.storeToken(jsonDecode(response.body));
      return saveAuth.getToken();
    } else {
      throw Exception();
    }
  }

  Future<Map<String, dynamic>> logout(String token) async {
    final url = Uri.parse('$baseurl/auth/logout');
    headers.addAll({'Authorization': 'Bearer $token'});

    final response = await http.post(url, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception(jsonDecode(response.body)['detail']);
    }
  }
}
