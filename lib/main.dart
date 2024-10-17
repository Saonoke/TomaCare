import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomacare/Models/plants.dart';
import 'package:tomacare/page/home_page.dart';
import 'page/login.dart';
import 'page/register.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
    create: (context) => Plants(),
    child: MaterialApp(
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage()
      },
    ),
  ));
}
