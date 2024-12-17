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

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: neutral06,
          title: Text(title),
          content: Text(content),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Postingan Baru'),
      ),
      body: BlocConsumer<ComunityBloc, ComunityState>(
        listener: (context, state) {
          if (state is ComunityPostLoaded) {
            Navigator.pop(context);
            Navigator.pop(context);
          } else if (state is ComunityError) {
            _showDialog(context, 'Gagal', 'Gagal memposting! Coba lagi.');
          } else if (state is ComunityLoading) {
            _showDialog(context, 'Proses', 'Silahkan Tunggu ...');
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(File(widget.image!.path)),
                ),
                const SizedBox(height: 24),
                _buildTextField('Judul', judulController),
                const SizedBox(height: 24),
                _buildTextField('Deskripsi', descController, maxLines: 8),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    context.read<ComunityBloc>().add(
                          CreatePost(
                            judulController.text,
                            descController.text,
                            widget.image!,
                          ),
                        );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Bagikan',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      height: 22 / 17,
                      letterSpacing: -0.408,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int? maxLines}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: label,
            labelText: label,
            labelStyle: const TextStyle(fontSize: 14),
            hintStyle: const TextStyle(fontSize: 14),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
