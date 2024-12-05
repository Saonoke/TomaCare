import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tomacare/domain/entities/plant.dart';
import 'package:tomacare/domain/entities/task.dart';
import 'package:tomacare/presentation/misc/constant/app_constant.dart';
import 'package:tomacare/presentation/plants/bloc/plants_bloc.dart';

class DetailPlantPage extends StatelessWidget {
  const DetailPlantPage({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlantsBloc(),
      child: DetailPlantScreen(
        index: index,
      ),
    );
  }
}

class DetailPlantScreen extends StatelessWidget {
  const DetailPlantScreen({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<PlantsBloc, PlantsState>(
          builder: (context, state) {
            switch (state) {
              case PlantsInitial():
                print('tes');
                context.read<PlantsBloc>()..add(PlantRequestById(id: index));
                return CircularProgressIndicator();
              case PlantsSuccess():
                final Plant plant = state.plants[0];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text(
                          plant.title,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: neutral01),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 32),
                        child: Text(
                          plant.condition,
                          style: TextStyle(fontSize: 16, color: neutral01),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 32),
                        child: Text(
                          "Tasks",
                          style: TextStyle(
                              fontSize: 16,
                              color: neutral01,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: plant.tasks!.length,
                            itemBuilder: (context, index) {
                              final Task task = plant.tasks![index];
                              return Card.outlined(
                                child: ListTile(
                                  title: Text(task.title),
                                  trailing: task.done
                                      ? Icon(Iconsax.tick_circle5)
                                      : Icon(Iconsax.tick_circle),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                );
              default:
                return Center(
                  child: Text('error'),
                );
            }
          },
          listener: (context, state) {}),
    );
  }
}
