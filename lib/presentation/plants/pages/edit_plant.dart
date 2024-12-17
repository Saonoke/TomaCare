import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomacare/presentation/Plants/bloc/plants_bloc.dart';
import 'package:tomacare/presentation/misc/constant/app_constant.dart';

class EditPlantPage extends StatelessWidget {
  const EditPlantPage({super.key, required this.plantId});
  final int plantId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlantsBloc()..add(PlantRequestById(id: plantId)),
      child: EditPlantScreen(),
    );
  }
}

class EditPlantScreen extends StatefulWidget {
  const EditPlantScreen({super.key});

  @override
  State<EditPlantScreen> createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends State<EditPlantScreen> {
  final judulController = TextEditingController();

  @override
  void dispose() {
    judulController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Tanaman'),
      ),
      body: BlocConsumer<PlantsBloc, PlantsState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is PlantsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PlantsSuccess) {
            judulController.text = state.plants[0].title;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              state.plants[0].image_path,
                              fit: BoxFit.fitWidth,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image),
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24, bottom: 16),
                            child: Text(
                              'Judul',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          TextFormField(
                            controller: judulController,
                            decoration: InputDecoration(
                              hintText: 'Judul',
                              labelText: 'Judul',
                              labelStyle: TextStyle(fontSize: 14),
                              hintStyle: TextStyle(fontSize: 14),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(1000)),
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 32),
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<PlantsBloc>().add(PlantEdit(
                            id: state.plants[0].id!,
                            title: judulController.text));
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
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is PlantsFailed) {
            return Center(child: Text(state.message.toString()));
          } else if (state is PlantsMessage) {
            Navigator.pop(context);
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
