import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:tomacare/domain/entities/plant.dart';
import 'package:tomacare/domain/entities/post.dart';
import 'package:tomacare/presentation/auth/bloc/auth_bloc.dart';
import 'package:tomacare/presentation/camera/pages/camera.dart';
import 'package:tomacare/presentation/comunity/bloc/comunity_bloc.dart';
import 'package:tomacare/presentation/comunity/page/community_page.dart';
import 'package:tomacare/presentation/comunity/page/create_community.dart';
import 'package:tomacare/presentation/misc/constant/app_constant.dart';
import 'package:tomacare/presentation/plants/bloc/plants_bloc.dart';

import 'package:tomacare/presentation/plants/pages/plant.dart';
import 'package:tomacare/presentation/user/page/menu_page.dart';
import 'package:tomacare/presentation/user/page/profile_page.dart';
import 'package:tomacare/presentation/weather/bloc/weather_bloc.dart';


class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<PlantsBloc>(create: (context) => PlantsBloc()),
      BlocProvider<ComunityBloc>(create: (context) => ComunityBloc()),
      BlocProvider<WeatherBloc>(create: (context) => WeatherBloc())
    ], child: HomePageScreen());
  }
}

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  Position? position;

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    final currentPosition = await Geolocator.getCurrentPosition();
    if (!mounted) return;
    setState(() {
      position = currentPosition;
    });
  }

  @override
  void initState() {
    _determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocConsumer<WeatherBloc, WeatherState>(
                  builder: (context, state) {
                    switch (state) {
                      case WeatherInitial():
                        if (position == null) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          context.read<WeatherBloc>()
                            ..add(getWeather(
                                latitude: position!.latitude,
                                longitude: position!.longitude));
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      case WeatherSuccess():
                        return Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(9))),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      state.placemarks[0].subAdministrativeArea
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: neutral06),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(Iconsax.arrow_right_1),
                                      color: neutral06,
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.temperature.round().toString() +
                                              '℃',
                                          style: TextStyle(
                                              fontSize: 54,
                                              fontWeight: FontWeight.bold,
                                              color: neutral06),
                                        ),
                                        Text(
                                          'Hujan Berangin',
                                          style: TextStyle(
                                              fontSize: 16, color: neutral06),
                                        )
                                      ],
                                    ),
                                    Icon(
                                      Iconsax.cloud_drizzle,
                                      size: 92,
                                      color: neutral06,
                                    )
                                  ],
                                )
                              ],
                            ));
                      default:
                        return Text('error');
                    }
                  },
                  listener: (context, state) {}),
              Padding(
                padding: const EdgeInsets.only(top: 32, bottom: 16),
                child: Text(
                  'Tanamanmu',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: neutral01),
                ),
              ),
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
                                  width: 245,
                                  height: 175,
                                  child: Card(
                                    color: neutral06,
                                    clipBehavior: Clip.antiAlias,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 130,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15)),
                                            child: Image.network(
                                              plant.image_path,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                plant.title,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: neutral01),
                                              ),
                                              Text(plant.condition)
                                            ],
                                          ),
                                        )
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
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 32, bottom: 16),
                child: Text(
                  'Komunitas',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: neutral01),
                ),
              ),
              BlocConsumer<ComunityBloc, ComunityState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    switch (state) {
                      case ComunityInitial():
                        context.read<ComunityBloc>()..add(ComunityStarted());
                        return CircularProgressIndicator();
                      case ComunityLoaded():
                        final List<Map<String, dynamic>> posts = state.posts;
                        return SizedBox(
                          width: double.maxFinite,
                          height: 200,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                final post = posts[index];
                                return Container(
                                  width: 300,
                                  height: 175,
                                  child: Card(
                                      clipBehavior: Clip.antiAlias,
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            height: double.maxFinite,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight:
                                                      Radius.circular(15)),
                                              child: Image.network(
                                                post['image_url'],
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: double.maxFinite,
                                            height: double.maxFinite,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                          Container(
                                            width: double.maxFinite,
                                            height: double.maxFinite,
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Text(
                                                post['title'],
                                                style:
                                                    TextStyle(color: neutral06),
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                );
                              }),
                        );

                      default:
                        return Center(
                          child: Text('tes'),
                        );
                    }
                  })
            ],
          ),
        ),
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
    PersonalPage()

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: bottomNavigation(context),
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
            Transform.translate(
              offset: const Offset(0, -30),
              child: RawMaterialButton(
                elevation: 5,
                constraints:
                    const BoxConstraints.tightFor(width: 80, height: 80),
                shape: CircleBorder(),
                fillColor: primaryColor,
                onPressed: () async {
                  if (pageIndex != 1) {
                    final cameras = await availableCameras();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CameraPage(cameras: cameras)));
                  } else {
                    XFile? image = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CreateCommunitypage(image: image)));
                  }
                },
                child: pageIndex == 1
                    ? Icon(
                        Iconsax.add,
                        size: 32,
                        color: neutral06,
                      )
                    : Icon(
                        Icons.camera_alt,
                        size: 32,
                        color: neutral06,
                      ),
              ),
            ),
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
    );
  }
}
