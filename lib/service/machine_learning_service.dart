import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:tomacare/presentation/misc/constant/app_constant.dart';
import 'package:http/http.dart' as http;
import 'package:tomacare/service/save_auth.dart';

class MachineLearningService {
  final SaveAuth saveService = SaveAuth();
  Future<Map<String, dynamic>> machineLearningProcess(XFile? image) async {
    final String? token = await saveService.getToken();
    final request =
        http.MultipartRequest('POST', Uri.parse('$baseurl/plants/upload/'));
    request.files.add(await http.MultipartFile.fromPath('file', image!.path));

    request.headers.addAll({
      'Authorization': 'Bearer $token', // Contoh header Authorization
      'Content-Type': 'multipart/form-data', // Opsional, biasanya otomatis
      'Custom-Header': 'CustomValue', // Header tambahan lain
    });
    print('start request');
    final response = await request.send();
    final responseData = await response.stream.toBytes();
    final responseString = String.fromCharCodes(responseData);
    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(responseString);
      return jsonMap;
    } else {
      throw Exception(jsonDecode(responseString));
    }
  }
}
