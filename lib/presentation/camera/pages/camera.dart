// import 'dart:convert';

import 'dart:io';
import 'dart:typed_data';
// import 'dart:developer' as developer;
import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import 'package:image_picker/image_picker.dart';

import 'package:photo_manager/photo_manager.dart';
import 'package:tomacare/domain/entities/information.dart';
import 'package:tomacare/presentation/camera/bloc/camera_bloc.dart';
import 'package:tomacare/presentation/misc/constant/app_constant.dart';
import 'package:tomacare/presentation/plants/pages/create_plant.dart';

// import 'package:path_provider/path_provider.dart';

// late List<CameraDescription> _cameras;

late List<String> pathImageList = [];

class CameraPage extends StatelessWidget {
  const CameraPage({super.key, required this.cameras});
  final List<CameraDescription> cameras;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CameraBloc(),
      child: CameraApp(cameras: cameras),
    );
  }
}

class CameraApp extends StatefulWidget {
  const CameraApp({super.key, required this.cameras});
  final List<CameraDescription> cameras;
  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  final ImagePicker _picker = ImagePicker();
  late CameraController controller;
  AssetEntity? latestImage;
  int index = 0;
  @override
  void initState() {
    super.initState();

    controller = CameraController(widget.cameras[index], ResolutionPreset.max);
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

  // Mendapatkan foto terbaru dari galeri
  Future<void> _fetchLatestImage() async {
    final List<AssetPathEntity> albums =
        await PhotoManager.getAssetPathList(type: RequestType.image);
    if (albums.isNotEmpty) {
      final List<AssetEntity> photos = await albums[0]
          .getAssetListPaged(page: 0, size: 1); // Ambil foto terbaru
      if (photos.isNotEmpty) {
        setState(() {
          latestImage = photos.first;
        });
      }
    }
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
      backgroundColor: Colors.black,
      body: BlocConsumer<CameraBloc, CameraState>(
        listener: (context, state) {
          if (state is CameraFailed) {
            Navigator.pop(context); // Menutup dialog loading
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: neutral06,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deteksi Gagal',
                      style: TextStyle(
                        color: neutral01,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text('Bukan daun tomat',
                        style: TextStyle(
                          color: neutral01,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                    ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                        child: Text(
                          'Ambil gambar baru',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              height: 22 / 17,
                              letterSpacing: -0.408),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            minimumSize: Size(double.infinity, 50))),
                  ],
                )));
          } else if (state is CameraLoading) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: neutral06,
                    title: Text('Proses'),
                    content: Text('Silahkan Tunggu ...'),
                  );
                });
          } else {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          switch (state) {
            case CameraTaken():
              return DisplayPictureScreen(
                image: state.file,
                predicted: state.predictedClass,
                percentage: state.percentage,
                information: state.information,
              );
            default:
              return Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 100),
                    child: CameraPreview(controller),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              XFile? image = await _picker.pickImage(
                                  source: ImageSource.gallery);
                              context.read<CameraBloc>()
                                ..add(CameraProcess(image: image));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[
                                    300], // Placeholder jika thumbnail belum ada
                                child: latestImage != null
                                    ? FutureBuilder<Uint8List?>(
                                        future: latestImage!
                                            .thumbnailDataWithSize(ThumbnailSize(
                                                200,
                                                200)), // Ambil data thumbnail
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                                  ConnectionState.done &&
                                              snapshot.hasData) {
                                            return Image.memory(
                                              snapshot.data!,
                                              fit: BoxFit.cover,
                                            );
                                          } else {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                        },
                                      )
                                    : Center(
                                        child: Icon(Icons.photo, size: 40)),
                              ),
                            ),
                          ),
                          FloatingActionButton.large(
                            shape: CircleBorder(),
                            backgroundColor: Colors.white,
                            onPressed: () async {
                              try {
                                XFile? image = await controller.takePicture();
                                context.read<CameraBloc>()
                                  ..add(CameraProcess(image: image));
                              } catch (e) {
                                print(e);
                              }
                            },
                            child: Icon(
                              Icons.circle_outlined,
                              size: 96,
                            ),
                          ),
                          FloatingActionButton(
                            shape: CircleBorder(),
                            backgroundColor: Colors.white,
                            onPressed: () {
                              setState(() {
                                index = index == 0 ? 1 : 0;
                                print("index = " + index.toString());
                                controller = CameraController(
                                    widget.cameras[index],
                                    ResolutionPreset.max);
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
                              });
                            },
                            child: Icon(
                              Iconsax.refresh_circle,
                              size: 32,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              );
          }
        },
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  const DisplayPictureScreen(
      {super.key,
      required this.image,
      required this.predicted,
      required this.percentage,
      required this.information});
  final String predicted;
  final double percentage;
  final XFile? image;
  final Information information;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: neutral03,
      appBar: AppBar(
        backgroundColor: neutral06,
        title: const Text('Diagnosis'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: neutral03,
              padding: EdgeInsets.all(16),
              width: double.maxFinite,
              child: Column(
                children: [
                  Text(
                    predicted,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(percentage.toInt().toString() + '%',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(image!.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: neutral06, borderRadius: BorderRadius.circular(16)),
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tentang ' + predicted,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(
                    information.type,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  Text(information.content)
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              decoration: BoxDecoration(
                  color: neutral06, borderRadius: BorderRadius.circular(16)),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pengobatan',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor)),
                  Divider(),
                  Text(information.medicine),
                  Padding(padding: const EdgeInsets.only(bottom: 6))
                ],
              ),
            ),
            Padding(padding: const EdgeInsets.only(bottom: 16))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        foregroundColor: neutral06,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CreatePlantPages(
                    image: image,
                    predicted: predicted,
                  )));
        },
        child: Icon(Icons.navigate_next_rounded),
      ),
    );
  }
}
