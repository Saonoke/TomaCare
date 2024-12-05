import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomacare/presentation/comunity/bloc/comunity_bloc.dart';
import 'package:tomacare/presentation/misc/constant/app_constant.dart';

class CreateCommunitypage extends StatelessWidget {
  const CreateCommunitypage({super.key, required this.image});
  final XFile? image;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ComunityBloc(),
      child: CreateCommunityScreen(image: image),
    );
  }
}

class CreateCommunityScreen extends StatefulWidget {
  const CreateCommunityScreen({super.key, required this.image});

  final XFile? image;

  @override
  State<CreateCommunityScreen> createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends State<CreateCommunityScreen> {
  final judulController = TextEditingController();
  final descController = TextEditingController();

  @override
  void dispose() {
    judulController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Postingan Baru'),
      ),
      body: BlocConsumer<ComunityBloc, ComunityState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(widget.image!.path),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 24, bottom: 16),
                      child: Text(
                        'Judul',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        controller: judulController,
                        decoration: InputDecoration(
                            hintText: 'Judul',
                            labelText: 'Judul',
                            labelStyle: TextStyle(fontSize: 14),
                            hintStyle: TextStyle(fontSize: 14),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1000))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24, bottom: 16),
                      child: Text(
                        'Deskripsi',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        maxLines: 8,
                        controller: descController,
                        decoration: InputDecoration(
                            hintText: 'Deskripsi',
                            hintStyle: TextStyle(fontSize: 14),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32, bottom: 32),
                      child: ElevatedButton(
                          onPressed: () {
                            context.read<ComunityBloc>()
                              ..add(CreatePost(judulController.text,
                                  descController.text, widget.image!));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: const Text(
                            'Bagikan',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                height: 22 / 17,
                                letterSpacing: -0.408),
                          )),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
