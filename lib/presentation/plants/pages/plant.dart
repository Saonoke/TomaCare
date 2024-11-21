import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomacare/domain/entities/plant.dart';
import 'package:tomacare/presentation/auth/bloc/auth_bloc.dart';
import 'package:tomacare/presentation/misc/constant/app_constant.dart';
import 'package:tomacare/presentation/plants/bloc/plants_bloc.dart';

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
                  return Center(
                      child: ListView.builder(
                    itemCount: plants.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.green,
                        child: Column(
                          children: [
                            Text(plants[index].title),
                            Text(plants[index].condition)
                          ],
                        ),
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
