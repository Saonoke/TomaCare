import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import 'package:tomacare/presentation/auth/bloc/auth_bloc.dart';
import 'package:tomacare/presentation/misc/constant/app_constant.dart';
import 'package:tomacare/presentation/page/community_page.dart';
import 'package:tomacare/presentation/plants/bloc/plants_bloc.dart';
import 'package:tomacare/presentation/plants/pages/plant.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: neutral06,
      body: Center(
        child: Text('home'),
      ),
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
        onPressed: () {},
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
