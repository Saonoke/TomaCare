import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tomacare/presentation/misc/constant/app_constant.dart';
import 'package:tomacare/service/save_auth.dart';

class ComunityService {
  final SaveAuth saveService = SaveAuth();

  Future<Map<String, dynamic>> createPost(
      {required String title,
      required String body,
      required String imagePath}) async {
    final url = Uri.parse('$baseurl/post/');
    final String? token = await saveService.getToken();

    headers.addAll({'authorization': 'Bearer $token'});

    final response = await http.post(url,
        headers: headers,
        body: jsonEncode({
          'title': title,
          'body': body,
          'image_path': imagePath,
        }));

    if (response.statusCode == HttpStatus.created) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body));
    }
  }

  Future<List<Map<String, dynamic>>> getAll([String? query]) async {
    final String queryString =
        query != null && query.isNotEmpty ? '?search=$query' : '';
    final url = Uri.parse('$baseurl/post/$queryString');

    final String? token = await saveService.getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception(jsonDecode(response.body)['detail']);
    }
  }

  Future<Map<String, dynamic>> getById(int id) async {
    final url = Uri.parse('$baseurl/post/$id');
    final String? token = await saveService.getToken();

    headers.addAll({'authorization': 'Bearer $token'});

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['detail'] ?? 'Unknown error');
    }
  }

  Future<List<Map<String, dynamic>>> getByUserId(int userId) async {
    final url = Uri.parse('$baseurl/post/user/$userId');
    final String? token = await saveService.getToken();

    headers.addAll({'authorization': 'Bearer $token'});

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception(jsonDecode(response.body)['detail'] ?? 'Unknown error');
    }
  }

  Future<bool> reaction(int postId, String reactionType) async {
    final url = Uri.parse('$baseurl/post/$postId/reaction');
    final String? token = await saveService.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };

    final response = await http.post(url,
        headers: headers, body: jsonEncode({"type": reactionType}));

    if ((response.statusCode == HttpStatus.ok) &&
        (jsonDecode(response.body)['success'] == true)) {
      return true;
    } else {
      throw Exception(jsonDecode(response.body)['detail']);
    }
  }
}
