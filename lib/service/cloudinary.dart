import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

class Cloudinary {
  Future<Map<String, dynamic>> upload(XFile image) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dtzlizlrs/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'tomacare'
      ..files.add(await http.MultipartFile.fromPath('file', image.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      return jsonMap;
    } else {
      throw Exception();
    }
  }
}
