// import 'dart:convert';
import 'dart:io';
// import 'dart:developer' as developer;
import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tomacare/page/addPlant.dart';
// import 'package:path_provider/path_provider.dart';

// late List<CameraDescription> _cameras;

late List<String> pathImageList = [];

class CameraApp extends StatefulWidget {
  const CameraApp({super.key, required this.cameras});
  final List<CameraDescription> cameras;

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
        appBar: AppBar(),
        body: CameraPreview(controller),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          // Provide an onPressed callback.
          onPressed: () async {
            // Take the Picture in a try / catch block. If anything goes wrong,
            // catch the error.
            try {
              // Attempt to take a picture and then get the location
              // where the image file is saved.
              final image = await controller.takePicture();
              final tempDir = await getApplicationDocumentsDirectory();

              final path = '${tempDir.path}/${image.name}';

              await File(image.path).copy(path);
              //   path.write(contents)

              // print(pathImageList);

              setState(() {
                pathImageList.add(path);
              });

              if (!context.mounted) return;

              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(
                        imagePath: path,
                        image: image,
                      )));
            } catch (e) {
              // If an error occurs, log the error to the console.
              print(e);
            }
          },
          child: const Icon(
            Icons.camera_alt,
            color: Colors.white,
          ),
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
        ));
  }
}

class DisplayPictureScreen extends StatelessWidget {
  const DisplayPictureScreen(
      {super.key, required this.imagePath, required this.image});
  final String imagePath;
  final XFile image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image'),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Image.file(File(imagePath))),
            Text("Filename : " + image.name),
            Text("Path : " + imagePath),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Addplant(imagePath: imagePath)));
        },
        child: Icon(Icons.navigate_next_rounded),
      ),
    );
  }
}
