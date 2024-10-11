import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tomacare/page/camera.dart';
// import 'package:tomacare/page/camera.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.cameras, Key? key}) : super(key: key);
  final List<CameraDescription> cameras;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CameraScreen(cameras: cameras),
      ),
    );
  }
}
