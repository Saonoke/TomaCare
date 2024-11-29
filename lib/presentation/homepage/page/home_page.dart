import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:iconsax/iconsax.dart';
import 'package:tomacare/domain/entities/plant.dart';
import 'package:tomacare/presentation/auth/bloc/auth_bloc.dart';
import 'package:tomacare/presentation/camera/pages/camera.dart';
import 'package:tomacare/presentation/comunity/bloc/comunity_bloc.dart';
import 'package:tomacare/presentation/comunity/page/community_page.dart';
import 'package:tomacare/presentation/misc/constant/app_constant.dart';
import 'package:tomacare/presentation/plants/bloc/plants_bloc.dart';

import 'package:tomacare/presentation/plants/pages/plant.dart';
import 'package:tomacare/presentation/page/profile_page.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<PlantsBloc>(create: (context) => PlantsBloc()),
      BlocProvider<ComunityBloc>(create: (context) => ComunityBloc())
    ], child: HomePageScreen());
  }
}

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          BlocConsumer<PlantsBloc, PlantsState>(
              listener: (context, state) {},
              builder: (context, state) {
                switch (state) {
                  case PlantsInitial():
                    context.read<PlantsBloc>()..add(PlantsRequest());
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  case PlantsSuccess():
                    final List<Plant> plants = state.plants;
                    return SizedBox(
                        width: double.maxFinite,
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: plants.length,
                          itemBuilder: (context, index) {
                            final plant = plants[index];
                            return Container(
                              width: 300,
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                color: Colors.green,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15)),
                                      child: Image.network(
                                        plant.image_path,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // Text(plants[index].title),
                                    // Text(plants[index].condition)
                                  ],
                                ),
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
              })
        ],
      )),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;

  final pages = [
    const HomePageView(),
    const CommunityPage(),
    const PlantPage(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: bottomNavigation(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.large(
        elevation: 0,
        shape: CircleBorder(),
        backgroundColor: primaryColor,
        foregroundColor: neutral06,
        onPressed: () async {
          final cameras = await availableCameras();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CameraPage(cameras: cameras)));
        },
        child: Icon(
          Icons.camera_alt,
          size: 48,
        ),
      ),
    );
  }

  Container bottomNavigation(BuildContext context) {
    return Container(
      height: 92,
      decoration: BoxDecoration(
        color: neutral06,
        boxShadow: [
          BoxShadow(
            color: neutral01,
            offset: const Offset(
              0.0,
              0.0,
            ),
            blurRadius: 10.0,
            spreadRadius: -7.0,
          ), //BoxShadow
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(right: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      enableFeedback: false,
                      onPressed: () {
                        setState(() {
                          pageIndex = 0;
                        });
                      },
                      icon: pageIndex == 0
                          ? const Icon(
                              Iconsax.home_2,
                              color: primaryColor,
                              size: 30,
                            )
                          : const Icon(
                              Iconsax.home_2,
                              color: neutral05,
                              size: 30,
                            ),
                    ),
                    IconButton(
                      enableFeedback: false,
                      onPressed: () {
                        setState(() {
                          pageIndex = 1;
                        });
                      },
                      icon: pageIndex == 1
                          ? const Icon(
                              Iconsax.message,
                              color: primaryColor,
                              size: 30,
                            )
                          : const Icon(
                              Iconsax.message,
                              color: neutral05,
                              size: 30,
                            ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      enableFeedback: false,
                      onPressed: () {
                        setState(() {
                          pageIndex = 2;
                        });
                      },
                      icon: pageIndex == 2
                          ? const Icon(
                              Iconsax.archive_2,
                              color: primaryColor,
                              size: 30,
                            )
                          : const Icon(
                              Iconsax.archive_2,
                              color: neutral05,
                              size: 30,
                            ),
                    ),
                    IconButton(
                      enableFeedback: false,
                      onPressed: () {
                        setState(() {
                          pageIndex = 3;
                        });
                      },
                      icon: pageIndex == 3
                          ? const Icon(
                              Iconsax.user_octagon,
                              color: primaryColor,
                              size: 30,
                            )
                          : const Icon(
                              Iconsax.user_octagon,
                              color: neutral05,
                              size: 30,
                            ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
