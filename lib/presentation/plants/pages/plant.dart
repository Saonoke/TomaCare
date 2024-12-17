import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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

class PlantList extends StatefulWidget {
  const PlantList({super.key});

  @override
  State<PlantList> createState() => _PlantListState();
}

class _PlantListState extends State<PlantList> {
  int? totalPlant;
  Map<String, dynamic>? statusCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: neutral06,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: BlocConsumer<PlantsBloc, PlantsState>(
                      builder: (context, state) {
                    switch (state) {
                      case PlantsInitial():
                        context.read<PlantsBloc>()..add(PlantsRequest());
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      case PlantsSuccess():
                        final List<Plant> plants = state.plants;

                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Hai ${state.username}",
                                          style: TextStyle(
                                              color: neutral01,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          DateFormat("MMM dd, yyyy")
                                              .format(DateTime.now()),
                                          style: TextStyle(
                                              fontSize: 16, color: neutral02),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: double.maxFinite,
                                height: 250,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          height: double.maxFinite,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                'images/plantIllustration.png',
                                                height: 80,
                                                fit: BoxFit.fitHeight,
                                              ),
                                              Text(
                                                'Total Tumbuhanmu \n ${plants.length}',
                                                style: TextStyle(
                                                    color: neutral06,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 32),
                                child: Text(
                                  'Tanamanmu',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: neutral01),
                                ),
                              ),
                              Container(
                                  height: 500,
                                  padding: EdgeInsets.only(top: 16),
                                  child: ListView.builder(
                                    itemCount: plants.length,
                                    itemBuilder: (context, index) {
                                      final Plant plant = plants[index];
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailPlantPage(
                                                        index: plant.id!,
                                                      )));
                                        },
                                        child: Card(
                                            elevation: 1.5,
                                            color: neutral06,
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: double.maxFinite,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: Image.network(
                                                        plant.image_path,
                                                        width: double.infinity,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5,
                                                            horizontal: 16),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          plant.title,
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: neutral01),
                                                        ),
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          plant.condition,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: neutral01),
                                                        ),
                                                        Text(
                                                          plant.date.toString(),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: neutral01),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )),
                                      );
                                    },
                                  )),
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 64))
                            ],
                          ),
                        );
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
                  }, listener: (context, state) {
                    if (state is PlantsSuccess) {
                      setState(() {
                        totalPlant = state.plants.length;
                        statusCount = state.status;
                      });
                    }
                  }),
                ),
              ],
            ),
          ),
        ));
  }
}
