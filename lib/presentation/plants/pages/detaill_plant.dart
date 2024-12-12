import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
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

class DetailPlantScreen extends StatefulWidget {
  const DetailPlantScreen({super.key, required this.index});
  final int index;

  @override
  State<DetailPlantScreen> createState() => _DetailPlantScreenState();
}

class _DetailPlantScreenState extends State<DetailPlantScreen> {
  List<Task>? tasksUtama;
  int indexTask = 0;

  List<String> generateDate(String currentDate) {
    // Tanggal awal
    DateFormat formatter = DateFormat("yyyy-MM-dd");

    // Parsing string ke DateTime
    DateTime startDate = formatter.parse(currentDate);

    // Menyimpan semua tanggal dalam 7 hari ke depan
    List<String> nextSevenDays = [];

    for (int i = 0; i < 7; i++) {
      DateTime nextDate = startDate.add(Duration(days: i));
      nextSevenDays.add(formatter.format(nextDate)); // Format sebagai string
    }
    return nextSevenDays;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<PlantsBloc, PlantsState>(
          builder: (context, state) {
            switch (state) {
              case PlantsInitial():
                context
                    .read<PlantsBloc>()
                    .add(PlantRequestById(id: widget.index));
                return CircularProgressIndicator();
              case PlantsSuccess():
                final Plant plant = state.plants[0];
                List<String> date = generateDate(plant.tasks![0].tanggal);
                // Inisialisasi tasksUtama jika null
                tasksUtama ??= plant.tasks!
                    .where((task) => task.tanggal == date[indexTask])
                    .toList();
                if (tasksUtama!.isEmpty) {
                  tasksUtama = null;
                }

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
                      SizedBox(
                        width: double.maxFinite,
                        height: 100,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: date.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    indexTask = index;
                                    tasksUtama = plant.tasks!
                                        .where((task) =>
                                            task.tanggal == date[index])
                                        .toList();
                                    if (tasksUtama!.isEmpty) {
                                      tasksUtama = null;
                                    }
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: index == indexTask
                                          ? primaryColor
                                          : Colors.black),
                                  width: 50,
                                  height: 100,
                                  child: Text(date[index]),
                                ),
                              );
                            }),
                      ),
                      tasksUtama == null
                          ? Expanded(
                              child: Center(
                              child: Text('Tidak ada task'),
                            ))
                          : Expanded(
                              child: ListView.builder(
                                itemCount: tasksUtama!.length,
                                itemBuilder: (context, index) {
                                  final Task task = tasksUtama![index];
                                  return Card.outlined(
                                    child: ListTile(
                                      title: Text(task.title),
                                      trailing: task.done
                                          ? Icon(Iconsax.tick_circle5)
                                          : Icon(Iconsax.tick_circle),
                                    ),
                                  );
                                },
                              ),
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
