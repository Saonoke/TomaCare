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
import 'package:tomacare/presentation/plants/pages/CreatePlant.dart';

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
      backgroundColor: neutral06,
      body: BlocConsumer<CameraBloc, CameraState>(
        listener: (context, state) {
          if (state is CameraFailed) {
            Navigator.pop(context); // Menutup dialog loading
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('gagal'),
                    content: Text(state.message),
                  );
                });
          } else if (state is CameraLoading) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('loading'),
                    content: Text('ahha'),
                  );
                });
          } else {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          switch (state) {
            case CameraTaken():
              print('hahja');
              return DisplayPictureScreen(
                image: state.file,
                predicted: state.predictedClass,
                percentage: state.percentage,
                information: state.information,
              );
            default:
              return Stack(
                children: [
                  CameraPreview(controller),
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
                            onPressed: () {},
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
      appBar: AppBar(
        title: const Text('Image'),
      ),
      body: Column(
        children: [
          Image.file(File(image!.path)),
          Text(predicted),
          Text(percentage.toString()),
          Text(information.content),
          Text(information.medicine)
        ],
      ),
      floatingActionButton: FloatingActionButton(
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
