import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomacare/domain/entities/plant.dart';
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
      backgroundColor: const Color(0xfff2f8f4),
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Image.file(
              File(widget.image!.path),
              height: 100,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  margin: const EdgeInsets.only(bottom: 11),
                  child: const Text(
                    'Nama Daun',
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        hintText: 'Nama Daun',
                        labelText: 'Nama Daun',
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  margin: const EdgeInsets.only(bottom: 11),
                  child: const Text(
                    'Deskripsi',
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    controller: descController,
                    decoration: InputDecoration(
                        hintText: 'Deskripsi',
                        labelText: 'Deskripsi',
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
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                    onPressed: () async {
                      final Map<String, dynamic> imagesUploaded =
                          await Cloudinary().upload(widget.image!);
                      context.read<PlantsBloc>()
                        ..add(PlantsCreate(
                            plant: Plant(
                                title: nameController.text,
                                condition: widget.predicted,
                                image_path: imagesUploaded['url'])));
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.green)),
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
