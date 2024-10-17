import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tomacare/Models/plants.dart';
import 'package:provider/provider.dart';

import 'package:tomacare/page/camera.dart';
import 'package:tomacare/page/community_page.dart';
import 'package:tomacare/page/plant.dart';
import 'package:tomacare/page/profile_page.dart';

late List<CameraDescription> _cameras;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return bottomNavbar();
  }
}

class bottomNavbar extends StatefulWidget {
  const bottomNavbar({super.key});

  @override
  State<bottomNavbar> createState() => _bottomNavbarState();
}

class _bottomNavbarState extends State<bottomNavbar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    MainPage(),
    CommunityPage(),
    plantList(),
    ProfilePage()
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add_check_rounded),
            label: 'Tes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Business',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.green[400],
        onTap: _onTap,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          WidgetsFlutterBinding.ensureInitialized();
          _cameras = await availableCameras();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CameraApp(cameras: _cameras),
              ));
        },
        backgroundColor: Colors.green[400],
        child: Icon(
          Icons.camera_alt_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f8f4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Hi, Naufal',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 22 / 20,
                        letterSpacing: -0.408,
                      ),
                    ),
                    Icon(
                      Icons.circle,
                      size: 40,
                    ),
                  ],
                ),
              ),
              weatherInfo(),
              Container(
                margin: const EdgeInsets.only(left: 15, top: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tanamanmu',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700, // Bold weight (700)
                        height: 22 / 20, // line-height / font-size
                        letterSpacing: -0.408, // sesuai dengan spesifikasi
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    // ListView horizontal
                    myPlants(context.watch<Plants>().plants),
                    const SizedBox(
                      height: 22,
                    ),
                    const Text(
                      'Rekomendasi Untukmu',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700, // Bold weight (700)
                        height: 22 / 20, // line-height / font-size
                        letterSpacing: -0.408, // sesuai dengan spesifikasi
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    // ListView horizontal
                    recomendation(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox recomendation() {
    return SizedBox(
      height: 160, // Tinggi dari ListView
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Scroll horizontal
        itemCount: 5, // Jumlah item
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Container(
              width: 282, // Lebar kontainer
              height: 160, // Tinggi kontainer
              margin: const EdgeInsets.only(right: 16), // Jarak antar kontainer
              decoration: BoxDecoration(
                color: Colors.blue[(index % 9 + 1) * 100], // Warna bervariasi
                borderRadius: BorderRadius.circular(16), // Radius sudut
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(16), // Radius sudut gambar
                    child: Image.network(
                      'https://s3-alpha-sig.figma.com/img/8d42/3cd3/2d6e44fb08f7a338d57ccbf74707af61?Expires=1730073600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=AIdnx7WprZxj-9UgX0nRFmX8fGQkQEk2vhHns-eBjqXM8kJsLo~F3fWL69oPHLN8LTScjMR95C4wbdT85ZEyd1hzvp9u8Ld5TY3AS4Kpnj6evrPnm-5HzKaB-YlTnVA2YBvzQEgset3nFGjN1~juBpWAlqLj2POT0RNSgYlyvo2LUG6Iq6JAiITDAFCXj~RWL1zsgfKdNy8ZHOPo1H-V85oQjrvsmH234RsN2e6FcO667qXjx0L3qATkojyYPD7Fnp3FMl7LeTAJIznRbGFECIDFm7vBj3VokjPbIEMIO25i~jc4NUmovOZeEim2qo~tM3XDYbJloRqV4Piq7kaDhg__',
                      width: 282,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 15, left: 15, bottom: 22, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 17,
                          width: 54,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: const ClipRect(
                            child: Center(
                              child: Text(
                                '10k Likes',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w500,
                                  height: 22 / 11, // line-height / font-size
                                  letterSpacing:
                                      -0.408, // sesuai dengan spesifikasi
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          'Lorem Ipsum',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600, // Bold weight (600)
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  SizedBox myPlants(List plants) {
    return SizedBox(
      height: 150, // Tinggi dari ListView
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Scroll horizontal
        itemCount: plants.length, // Jumlah item
        itemBuilder: (context, index) {
          final plant = plants.elementAt(index);
          return Container(
              width: 150, // Lebar kontainer
              height: 150, // Tinggi kontainer
              margin: const EdgeInsets.only(right: 16), // Jarak antar kontainer
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16), // Radius sudut
                // Menggunakan warna latar belakang sebagai fallback
              ),
              child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(16), // Radius sudut gambar
                  child: plant.image.startsWith('images/')
                      ? Image.asset(
                          plant.image,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(plant.image),
                          fit: BoxFit.cover,
                        )));
        },
      ),
    );
  }

  Container weatherInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 22, left: 10, right: 10),
      padding: const EdgeInsets.only(top: 27, left: 28, right: 26, bottom: 25),
      height: 181,
      decoration: BoxDecoration(
          color: const Color(0xff27AE61),
          borderRadius: BorderRadius.circular(10)),
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Malang, Indonesia',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 22 / 18, // line-height / font-size
                    letterSpacing: -0.408, // sesuai dengan spesifikasi
                    color: Colors.white),
              ),
              Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '18',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                      fontWeight: FontWeight.w700,
                      height: 22 / 25, // line-height / font-size
                      letterSpacing: -0.408, // sesuai dengan spesifikasi
                    ),
                  ),
                  Text(
                    'Rain Wind',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400, // normal weight (400)
                      height: 22 / 18, // line-height / font-size
                      letterSpacing: -0.408, // sesuai spesifikasi
                    ),
                  )
                ],
              ),
              Icon(
                Icons.cloudy_snowing,
                color: Colors.white,
                size: 100,
              ),
            ],
          )
        ],
      ),
    );
  }
}
