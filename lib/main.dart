import 'package:flutter/material.dart';
import 'page/home_page.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/home': (context) => HomePage(),
    },
  ));
}