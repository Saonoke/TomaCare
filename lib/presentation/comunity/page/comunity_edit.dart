import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomacare/presentation/comunity/bloc/comunity_bloc.dart';
import 'package:tomacare/presentation/misc/constant/app_constant.dart';

class EditCommunitypage extends StatelessWidget {
  const EditCommunitypage({super.key, required this.postId});
  final int postId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ComunityBloc()..add(EditPost(postId)),
      child: EditCommunityScreen(),
    );
  }
}

class EditCommunityScreen extends StatefulWidget {
  const EditCommunityScreen({super.key});

  @override
  State<EditCommunityScreen> createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends State<EditCommunityScreen> {
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
        title: Text('Edit Postingan'),
      ),
      body: BlocConsumer<ComunityBloc, ComunityState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is EditPostLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is EditPostLoaded) {
            judulController.text = state.post['title'];
            descController.text = state.post['body'];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        state.post['image_url'], // URL gambar
                        fit: BoxFit
                            .cover, // Menyesuaikan gambar agar memenuhi area
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons
                                .broken_image), // Placeholder jika gambar gagal dimuat
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child:
                                CircularProgressIndicator(), // Indikator loading
                          );
                        },
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
                              context.read<ComunityBloc>().add(EditPostAction(
                                  state.post['id'],
                                  judulController.text,
                                  descController.text));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              minimumSize: Size(double.infinity, 50),
                            ),
                            child: const Text(
                              'Simpan',
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
          } else if (state is EditPostFailed) {
            return Center(child: Text(state.message.toString()));
          } else if (state is EditPostSuccess) {
            Navigator.pop(
              context,
            );
          }
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
