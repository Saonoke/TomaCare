import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomacare/domain/entities/plant.dart';
import 'package:tomacare/presentation/auth/bloc/auth_bloc.dart';
import 'package:tomacare/presentation/misc/constant/app_constant.dart';
import 'package:tomacare/presentation/plants/bloc/plants_bloc.dart';
import 'package:tomacare/presentation/plants/pages/detaill_plant.dart';

class PlantPage extends StatelessWidget {
  const PlantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlantsBloc(),
      child: PlantList(),
    );
  }
}

class PlantList extends StatelessWidget {
  const PlantList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: neutral06,
        body: BlocConsumer<PlantsBloc, PlantsState>(
            builder: (context, state) {
              switch (state) {
                case PlantsInitial():
                  context.read<PlantsBloc>()..add(PlantsRequest());
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                case PlantsSuccess():
                  final List<Plant> plants = state.plants;
                  return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: ListView.builder(
                        itemCount: plants.length,
                        itemBuilder: (context, index) {
                          final Plant plant = plants[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailPlantPage(
                                            index: plant.id!,
                                          )));
                            },
                            child: Card(
                                elevation: 0,
                                color: neutral03,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            bottomLeft: Radius.circular(12)),
                                        child: Image.network(
                                          plant.image_path,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            plant.title,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: neutral01),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            plant.condition,
                                            style: TextStyle(
                                                fontSize: 16, color: neutral01),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          );
                        },
                      ));
                case PlantsLoading():
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                case PlantsFailed():
                  return Center(
                    child: ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(Logout());
                        },
                        child: Text('logout')),
                  );

                case PlantsMessage():
                  return Center(
                    child: Text('error message'),
                  );
              }
            },
            listener: (context, state) {}));
  }
}
