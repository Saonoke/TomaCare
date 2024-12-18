import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomacare/presentation/auth/bloc/auth_bloc.dart';
import 'package:tomacare/presentation/auth/page/register.dart';
import 'package:tomacare/presentation/homepage/page/home_page.dart';
import 'package:tomacare/presentation/splashscreen.dart';

import 'presentation/auth/page/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  CloudinaryContext.cloudinary =
      Cloudinary.fromCloudName(cloudName: 'dtzlizlrs');
  runApp(
    BlocProvider(
      create: (_) => AuthBloc(),
      child: MaterialApp(
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
        ),
        routes: {
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/home': (context) => HomePage(),
          '/': (context) => Splashscreen(),
        },
      ),
    ),
  );
}
