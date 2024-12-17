import 'dart:convert';
import 'dart:io';

import 'package:tomacare/presentation/misc/constant/app_constant.dart';
import 'package:tomacare/service/save_auth.dart';
import 'package:tomacare/domain/entities/task.dart';
import 'package:http/http.dart' as http;

class TaskService {
  final SaveAuth saveService = SaveAuth();

  Future<Task> updatePost({required Task task, required int plantId}) async {
    final url = Uri.parse('$baseurl/plants/task/${plantId}');
    final String? token = await saveService.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };

    final response =
        await http.put(url, headers: headers, body: jsonEncode(task.toJson()));

    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Task.fromJson(data);
    } else {
      throw Exception(response.body);
    }
  }
}
