import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tomacare/Models/Plant.dart';
import 'package:tomacare/Models/plants.dart';
import 'package:provider/provider.dart';

class Addplant extends StatefulWidget {
  const Addplant({super.key, required this.imagePath});
  final imagePath;
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
      backgroundColor:const Color(0xfff2f8f4) ,
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Image.file(
              File(widget.imagePath),
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
                            horizontal: 29, vertical: 13),
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
                            horizontal: 29, vertical: 13),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1000))),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  context.read<Plants>().addPlant(Plant(
                      nama: nameController.text,
                      deskripsi: descController.text,
                      image: widget.imagePath));
                  Navigator.pushNamed(context, '/home');
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.green)),
                child: Text(
                  'Tambah',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
