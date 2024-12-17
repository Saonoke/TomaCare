import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tomacare/domain/entities/plant.dart';
import 'package:tomacare/domain/entities/task.dart';
import 'package:tomacare/presentation/misc/constant/app_constant.dart';
import 'package:tomacare/presentation/plants/bloc/plants_bloc.dart';
import 'package:tomacare/presentation/plants/pages/edit_plant.dart';
import 'package:tomacare/tasks/bloc/tasks_bloc.dart';

class DetailPlantPage extends StatelessWidget {
  const DetailPlantPage({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PlantsBloc>(create: (context) => PlantsBloc()),
        BlocProvider<TasksBloc>(create: (context) => TasksBloc())
      ],
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

                return Column(
                  children: [
                    SafeArea(
                      child: Stack(
                        children: [
                          SizedBox(
                            width: double.maxFinite,
                            height: 200,
                            child: ClipRRect(
                              child: Image.network(
                                plant.image_path,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: double.maxFinite,
                            height: 200,
                            color: Colors.black.withOpacity(0.6),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Iconsax.arrow_left),
                              color: neutral06,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: PopupMenuButton<String>(
                              menuPadding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.more_vert, // Ellipsis icon
                                color: Colors.white,
                              ),
                              color: Colors.white,
                              onSelected: (value) {
                                if (value == 'edit') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditPlantPage(
                                                plantId: plant.id!,
                                              ))).then(
                                    (value) {
                                      context.read<PlantsBloc>().add(
                                          PlantRequestById(id: widget.index));
                                    },
                                  );
                                } else if (value == 'delete') {
                                  // _deletePost(state.post['id']);
                                }
                              },
                              itemBuilder: (BuildContext context) => [
                                const PopupMenuItem<String>(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            width: double.maxFinite,
                            height: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Text(
                                    plant.title,
                                    style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: neutral06),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 16),
                                  child: Text(
                                    plant.condition,
                                    style: TextStyle(
                                        fontSize: 16, color: neutral06),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                "Tugas",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: neutral01,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              width: double.maxFinite,
                              height: 120,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: date.length,
                                  itemBuilder: (context, index) {
                                    DateTime tanggal = DateFormat("yyyy-MM-dd")
                                        .parse(date[index]);
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
                                        margin: EdgeInsets.only(right: 12),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            color: index == indexTask
                                                ? primaryColor
                                                : neutral03),
                                        width: 80,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                tanggal.day.toString(),
                                                style: TextStyle(
                                                    color: index == indexTask
                                                        ? neutral06
                                                        : neutral01,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                DateFormat.E().format(tanggal),
                                                style: TextStyle(
                                                    color: index == indexTask
                                                        ? neutral06
                                                        : neutral01,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
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
                                    child: BlocConsumer<TasksBloc, TasksState>(
                                      listener: (context, state) {
                                        if (state is TasksSuccess) {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text('Tes'),
                                                  content: const Text(
                                                      'Berhasil Di update'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'Selesai'))
                                                  ],
                                                );
                                              });
                                        }
                                      },
                                      builder: (context, state) {
                                        return ListView.builder(
                                          itemCount: tasksUtama!.length,
                                          itemBuilder: (context, index) {
                                            final Task task =
                                                tasksUtama![index];
                                            return GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (Dialogcontext) {
                                                      return AlertDialog(
                                                        title:
                                                            const Text('Tes'),
                                                        content: const Text(
                                                            'Sudah Selesai ?'),
                                                        actions: [
                                                          Builder(builder:
                                                              (buttoncontext) {
                                                            return TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          Dialogcontext)
                                                                      .pop();
                                                                  Task
                                                                      task_update =
                                                                      task;
                                                                  task_update
                                                                          .done =
                                                                      true;
                                                                  context
                                                                      .read<
                                                                          TasksBloc>()
                                                                      .add(updateTask(
                                                                          task:
                                                                              task,
                                                                          plantId:
                                                                              plant.id!));
                                                                },
                                                                child: const Text(
                                                                    'Selesai'));
                                                          }),
                                                          TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child:
                                                                  Text('batal'))
                                                        ],
                                                      );
                                                    });
                                              },
                                              child: Card.outlined(
                                                child: ListTile(
                                                  title: Text(task.title),
                                                  trailing: task.done
                                                      ? Icon(
                                                          Iconsax.tick_circle5,
                                                          color: primaryColor,
                                                        )
                                                      : Icon(
                                                          Iconsax.tick_circle),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              default:
                return Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
            }
          },
          listener: (context, state) {}),
    );
  }
}
