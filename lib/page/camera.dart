import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({required this.cameras, Key? key}) : super(key: key);
  final List<CameraDescription> cameras;

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {

  late CameraController _cameraController;

  late Future<void> cameraValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cameraController = CameraController(widget.cameras[0],ResolutionPreset.high);
    cameraValue = _cameraController.initialize();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
      children: [
        FutureBuilder(
            future: cameraValue,
            builder: (context,snapshot) {
          if(snapshot.connectionState==ConnectionState.done){
            return CameraPreview(_cameraController);
          }
          else{
            return Center(
              child: CircularProgressIndicator(),
            );

          }
        }
        )
      ],
      ),
    );
  }
}