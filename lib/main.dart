import 'package:flutter/material.dart';
import 'page/login.dart';
import 'page/register.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/login',
    routes: {
      '/login': (context) => LoginPage(),
      '/register': (context) => RegisterPage()
    },
  ));
}
