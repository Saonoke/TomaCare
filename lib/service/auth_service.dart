import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
// import 'package:tomacare/domain/entities/auth.dart';
import 'package:tomacare/presentation/misc/constant/app_constant.dart';

class AuthService {
  Future<String?> login(
      {required String emailOrUsername, required String password}) async {
    final url = Uri.parse('$baseurl/auth/token');

    final response = await http.post(url,
        headers: headers,
        body: jsonEncode(
            {'email_or_username': emailOrUsername, 'password': password}));

    if (response.statusCode == HttpStatus.ok) {
      return jsonDecode(response.body)['access_token'];
    } else {
      throw Exception(jsonDecode(response.body)['detail']);
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

  Future<String?> googleLogin(
      {required String googleAccessToken}) async {
    final url = Uri.parse('$baseurl/auth/google');

    final response = await http.post(url,
        headers: headers,
        body: jsonEncode(
            {'google_access_token': googleAccessToken}));

    if (response.statusCode == HttpStatus.ok) {
      return jsonDecode(response.body)['access_token'];
    } else {
      throw Exception(jsonDecode(response.body)['detail']);
    }
  }
}
