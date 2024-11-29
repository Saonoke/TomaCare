import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:tomacare/presentation/misc/constant/app_constant.dart';

class Mltes extends StatefulWidget {
  const Mltes({super.key});

  @override
  State<Mltes> createState() => _MltesState();
}

class _MltesState extends State<Mltes> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final request =
          http.MultipartRequest('POST', Uri.parse('$baseurl/plants/upload/'));
      request.files
          .add(await http.MultipartFile.fromPath('file', pickedFile.path));
      print('start request');
      final response = await request.send();

      if (response.statusCode == 200) {
        print(response.toString());
      } else {
        print('error upload');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // runML();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TFLite Example')),
      body: Column(
        children: [
          _image != null
              ? Image.file(_image!)
              : Text('No image selected', style: TextStyle(fontSize: 18)),
          ElevatedButton(
            onPressed: () async {
              await pickImage();
              if (_image != null) {}
            },
            child: Text('Pick Image & Run Inference'),
          ),
        ],
      ),
    );
  }
}
