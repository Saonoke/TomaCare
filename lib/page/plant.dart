import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tomacare/Models/plants.dart';
import 'package:provider/provider.dart';
import 'package:tomacare/page/plantDetails.dart';

class plantList extends StatefulWidget {
  const plantList({super.key});

  @override
  State<plantList> createState() => _plantListState();
}

class _plantListState extends State<plantList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f8f4),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ListView.builder(
            itemCount: context.watch<Plants>().plants.length,
            itemBuilder: (context, index) {
              final plant = context.watch<Plants>().plants.elementAt(index);
              return Card(
                color: const Color.fromARGB(255, 255, 255, 255),
                child: ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Plantdetails(plant: plant)));
                  },
                  leading: plant.image.startsWith('images/')
                      ? Image.asset(
                          plant.image,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(plant.image),
                          fit: BoxFit.cover,
                        ),
                  title: Text(plant.nama),
                  subtitle: Text(plant.deskripsi),
                ),
              );
            }),
      ),
    );
  }
}
