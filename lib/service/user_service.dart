import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:tomacare/service/cloudinary.dart';
import 'package:tomacare/domain/entities/user.dart';
import 'package:tomacare/presentation/misc/constant/app_constant.dart';
import 'package:http/http.dart' as http;
import 'package:tomacare/service/save_auth.dart';

class UserService {
  final SaveAuth saveService = SaveAuth();
  final Cloudinary cloudinary = Cloudinary();

  Future<Map<String, dynamic>> fetchUser() async {
    final url = Uri.parse('$baseurl/user');
    final String? token = await saveService.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception(jsonDecode(response.body)['detail']);
    }
  }

  Future<Map<String, dynamic>> updateUser(User user, XFile? profileImage) async {
    final url = Uri.parse('$baseurl/user');
    var res;

    final String? token = await saveService.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };

    if (profileImage != null) {
      res = await cloudinary.upload(profileImage);
      user.profileImg = res['url'];
    }

    final response = await http.put(url,
        headers: headers, body: jsonEncode((user.toJson())));

    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception(jsonDecode(response.body)['detail']);
    }
  }

  Future<Map<String, dynamic>> changePassword(String? newPassword, String? oldPassword) async {
    final url = Uri.parse('$baseurl/user/password');

    final String? token = await saveService.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };

    print(headers);

    final response = await http.put(
        url,
        headers: headers, body: jsonEncode({
          'old_password': oldPassword,
          'new_password': newPassword
        }));

    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception(jsonDecode(response.body)['detail']);
    }
  }

  Future<Map<String, dynamic>> createPassword(String? password) async {
    final url = Uri.parse('$baseurl/user/password');

    final String? token = await saveService.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };

    final response = await http.post(url,
        headers: headers, body: jsonEncode({
          'password': password,
        }));

    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception(jsonDecode(response.body)['detail']);
    }
  }
}
