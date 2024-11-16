import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Plantdetails extends StatelessWidget {
  const Plantdetails({super.key, required this.plant});
  final plant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plant.nama),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            plant.image.startsWith('images/')
                ? Image.asset(
                    plant.image,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(plant.image),
                    fit: BoxFit.cover,
                  ),
            Text("Nama : " + plant.nama),
            Text("Deskripsi : " + plant.deskripsi)
          ],
        ),
      ),
    );
  }
}
