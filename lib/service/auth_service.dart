import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
// import 'package:tomacare/domain/entities/auth.dart';
import 'package:tomacare/presentation/misc/constant/app_constant.dart';

class AuthService {
  Future<String?> login(
      {required String emailOrUsername, required String password}) async {
    print('start service');
    final url = Uri.parse('$baseurl/auth/token');
    try {
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(
              {'email_or_username': emailOrUsername, 'password': password}));

      if (response.statusCode == HttpStatus.ok) {
        print(response.body);
        return jsonDecode(response.body)['access_token'];
      } else {
        print(response.body);
        return throw Exception();
      }
    } catch (e) {
      print(e);
      return throw Exception();
    }
  }
}
