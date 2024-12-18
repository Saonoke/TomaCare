import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tomacare/domain/entities/plant.dart';
import 'package:tomacare/presentation/misc/constant/app_constant.dart';
import 'package:tomacare/presentation/plants/bloc/plants_bloc.dart';
import 'package:tomacare/service/cloudinary.dart';

class CreatePlantPages extends StatelessWidget {
  const CreatePlantPages(
      {super.key, required this.image, required this.predicted});
  final XFile? image;
  final String predicted;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlantsBloc(),
      child: Addplant(
        image: image,
        predicted: predicted,
      ),
    );
  }
}

class Addplant extends StatefulWidget {
  const Addplant({super.key, required this.image, required this.predicted});
  final XFile? image;
  final String predicted;
  @override
  State<Addplant> createState() => _AddplantState();
}

class _AddplantState extends State<Addplant> {
  final nameController = TextEditingController();
  final descController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: neutral06,
      appBar: AppBar(
        backgroundColor: neutral06,
        centerTitle: true,
        title: Text(
          'Tambah tumbuhan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(
              width: double.maxFinite,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(widget.image!.path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  margin: const EdgeInsets.only(bottom: 11),
                  child: const Text(
                    'Nama Tumbuhan',
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        hintText: 'Nama Tumbuhan',
                        labelText: 'Nama Tumbuhan',
                        labelStyle: TextStyle(fontSize: 14),
                        hintStyle: TextStyle(fontSize: 14),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1000))),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            BlocConsumer<PlantsBloc, PlantsState>(
              listener: (context, state) {
                if (state is PlantsMessage) {
                  Navigator.of(context).pushNamed('/home');
                } else if (state is PlantsLoading) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: neutral06,
                          title: Text('Proses'),
                          content: Text('Silahkan Tunggu ...'),
                        );
                      });
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                    onPressed: () async {
                      final Map<String, dynamic> imagesUploaded =
                          await Cloudinary().upload(widget.image!);

                      context.read<PlantsBloc>().add(PlantsCreate(
                            plant: Plant(
                                title: nameController.text,
                                condition: widget.predicted,
                                image_path: imagesUploaded['url'],
                                date: DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now())),
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      'Tambah',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ));
              },
            )
          ],
        ),
      ),
    );
  }
}
