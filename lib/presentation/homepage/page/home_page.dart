import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tomacare/domain/entities/information.dart';
import 'package:tomacare/domain/entities/plant.dart';
import 'package:tomacare/presentation/auth/bloc/auth_bloc.dart';
import 'package:tomacare/presentation/camera/pages/camera.dart';
import 'package:tomacare/presentation/comunity/bloc/comunity_bloc.dart';
import 'package:tomacare/presentation/comunity/page/community_page.dart';
import 'package:tomacare/presentation/comunity/page/create_community.dart';
import 'package:tomacare/presentation/information/bloc/information_bloc.dart';
import 'package:tomacare/presentation/misc/constant/app_constant.dart';
import 'package:tomacare/presentation/plants/bloc/plants_bloc.dart';
import 'package:tomacare/presentation/plants/pages/plant.dart';
import 'package:tomacare/presentation/user/page/menu_page.dart';
import 'package:tomacare/presentation/weather/bloc/weather_bloc.dart';
import 'package:tomacare/presentation/weather/pages/weather_pages.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<PlantsBloc>(create: (context) => PlantsBloc()),
      BlocProvider<ComunityBloc>(create: (context) => ComunityBloc()),
      BlocProvider<WeatherBloc>(create: (context) => WeatherBloc()),
      BlocProvider<InformationBloc>(create: (context) => InformationBloc())
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
      await Geolocator.openLocationSettings();
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
    try {
      final currentPosition = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      setState(() {
        position = currentPosition;
      });
    } catch (e) {
      return Future.error('Failed to get location: $e');
    }
  }

  @override
  void initState() {
    _determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: neutral06,
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
                              child: Skeletonizer(
                            enabled: true,
                            enableSwitchAnimation: true,
                            child: Card(
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  child: Column(children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'krisna andika',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: neutral06),
                                        ),
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
                                              'Tes',
                                              style: TextStyle(
                                                  fontSize: 54,
                                                  fontWeight: FontWeight.bold,
                                                  color: neutral06),
                                            ),
                                            Text(
                                              "krisna",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: neutral06),
                                            )
                                          ],
                                        ),
                                        weatherIcon(WeatherCondition.cerah)
                                      ],
                                    ),
                                  ])),
                            ),
                          ));
                        } else {
                          context.read<WeatherBloc>().add(getWeather(
                              latitude: position!.latitude,
                              longitude: position!.longitude));
                          return Center(
                              child: Skeletonizer(
                            enabled: true,
                            enableSwitchAnimation: true,
                            child: Card(
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  child: Column(children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'krisna andika',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: neutral06),
                                        ),
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
                                              'Tes',
                                              style: TextStyle(
                                                  fontSize: 54,
                                                  fontWeight: FontWeight.bold,
                                                  color: neutral06),
                                            ),
                                            Text(
                                              "krisna",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: neutral06),
                                            )
                                          ],
                                        ),
                                        weatherIcon(WeatherCondition.cerah)
                                      ],
                                    ),
                                  ])),
                            ),
                          ));
                        }
                      case WeatherSuccess():
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WeatherPages(
                                            position: position,
                                            conditon: state.weatherCondition,
                                            temperature: state.temperature,
                                          )));
                            },
                            child: WeatherCard(state));
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
                        context.read<PlantsBloc>().add(PlantsRequest());

                        return Container();
                      case PlantsSuccess():
                        final List<Plant> plants = state.plants;
                        return plants_slider(plants);
                      case PlantsLoading():
                        return SizedBox(
                          width: double.maxFinite,
                          height: 175,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Skeletonizer(
                                    enabled: true,
                                    enableSwitchAnimation: true,
                                    child: SizedBox(
                                      width: 175,
                                      child: Card(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 100,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('title'),
                                                  Text('condition')
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ));
                              }),
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
                  'Berbagi di komunitas',
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
                      case ComunityLoaded():
                        final List<Map<String, dynamic>> posts = state.posts;
                        return CommunitySlider(posts);

                      case ComunityError():
                        return Center(
                          child: Text('tes'),
                        );

                      case ComunityInitial():
                        context.read<ComunityBloc>().add(ComunityStarted());
                        return Container();

                      default:
                        return SizedBox(
                          width: double.maxFinite,
                          height: 175,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Skeletonizer(
                                    enabled: true,
                                    enableSwitchAnimation: true,
                                    child: SizedBox(
                                      width: 300,
                                      height: 120,
                                      child: Card(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('title'),
                                                  Text('condition')
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ));
                              }),
                        );
                    }
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 32, bottom: 16),
                child: Text(
                  'Pahami lebih banyak',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: neutral01),
                ),
              ),
              BlocConsumer<InformationBloc, InformationState>(
                  builder: (context, state) {
                    switch (state) {
                      case InformationInitial():
                        context.read<InformationBloc>().add(getInformation());
                        return CircularProgressIndicator();

                      case InformationSuccess():
                        final List<Information> informations =
                            state.informations;
                        return InformationSlider(informations: informations);

                      default:
                        return SizedBox(
                          width: double.maxFinite,
                          height: 175,
                          child: ListView.builder(
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Skeletonizer(
                                    enabled: true,
                                    enableSwitchAnimation: true,
                                    child: SizedBox(
                                      child: Card(
                                          child: ListTile(
                                        title: Text('tomato bacterial spot'),
                                        subtitle: Text('bakteri'),
                                      )),
                                    ));
                              }),
                        );
                    }
                  },
                  listener: (context, state) {}),
              Padding(padding: const EdgeInsets.only(bottom: 25))
            ],
          ),
        ),
      )),
    );
  }

  SizedBox CommunitySlider(List<Map<String, dynamic>> posts) {
    return SizedBox(
      width: double.maxFinite,
      height: 150,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];

            return SizedBox(
              width: 275,
              child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: double.maxFinite,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)),
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
                        color: Colors.black.withOpacity(0.5),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        width: double.maxFinite,
                        height: double.maxFinite,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            post['title'],
                            style: TextStyle(color: neutral06),
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        width: double.maxFinite,
                        height: double.maxFinite,
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                  color: neutral06,
                                  borderRadius: BorderRadius.circular(1000)),
                              child: Text(
                                textAlign: TextAlign.center,
                                post['count_like'].toString() + ' Likes',
                                style: TextStyle(color: neutral01),
                              ),
                            )),
                      )
                    ],
                  )),
            );
          }),
    );
  }

  SizedBox plants_slider(List<Plant> plants) {
    return SizedBox(
        width: double.maxFinite,
        height: 175,
        child: plants.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Mulai scan pertamamu',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text(
                          'Ambil gambar',
                          style: TextStyle(
                              color: neutral06,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              )
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: plants.length,
                itemBuilder: (context, index) {
                  final plant = plants[index];
                  return SizedBox(
                    width: 175,
                    child: Card(
                      elevation: 3,
                      color: neutral06,
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 100,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
  }

  Container WeatherCard(WeatherSuccess state) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(9))),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  state.placemarks[0].subAdministrativeArea.toString(),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.temperature.round().toString() + '℃',
                      style: TextStyle(
                          fontSize: 54,
                          fontWeight: FontWeight.bold,
                          color: neutral06),
                    ),
                    Text(
                      state.weatherCondition.name,
                      style: TextStyle(fontSize: 16, color: neutral06),
                    )
                  ],
                ),
                weatherIcon(state.weatherCondition)
              ],
            )
          ],
        ));
  }

  Icon weatherIcon(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.cerah:
        return Icon(
          Iconsax.sun_1,
          size: 92,
          color: neutral06,
        );
      case WeatherCondition.berawan:
        return Icon(
          Iconsax.cloud_sunny,
          size: 92,
          color: neutral06,
        );
      case WeatherCondition.hujan:
        return Icon(
          Iconsax.cloud_drizzle,
          size: 92,
          color: neutral06,
        );
      case WeatherCondition.salju:
        return Icon(
          Iconsax.sun,
          size: 92,
          color: neutral06,
        );
      default:
        return Icon(
          Iconsax.cloud_cross,
          size: 92,
          color: neutral06,
        );
    }
  }
}

class InformationSlider extends StatelessWidget {
  const InformationSlider({
    super.key,
    required this.informations,
  });

  final List<Information> informations;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 150,
      child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            final Information information = informations[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                width: 300,
                height: 120,
                child: Card(
                  elevation: 3,
                  color: neutral06,
                  clipBehavior: Clip.antiAlias,
                  child: Row(
                    children: [
                      SizedBox(
                          height: double.infinity,
                          child: ClipRRect(
                            child: Image.network(
                                'https://i.pinimg.com/474x/ae/bd/32/aebd3210fda7a94ff810e0a9abb99715.jpg'),
                          )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              information.title,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 12),
                              decoration: BoxDecoration(
                                  color: Colors.red.shade800,
                                  borderRadius: BorderRadius.circular(1000)),
                              child: Text(
                                information.type,
                                style: TextStyle(color: neutral06),
                              ),
                            )
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            );
          }),
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

                    if (image != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CreateCommunitypage(image: image)));
                    }
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
