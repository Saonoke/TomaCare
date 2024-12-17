import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomacare/presentation/auth/bloc/auth_bloc.dart';
import 'package:tomacare/presentation/misc/constant/app_constant.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  late final AuthBloc authBloc;
  late StreamSubscription authStream;

  @override
  void initState() {
    authBloc = context.read<AuthBloc>()..add(AppStarted());

    authStream = authBloc.stream.listen((state) {
      Future.delayed(const Duration(seconds: 2)).then((_) {
        if (mounted) {
          switch (state) {
            case AuthFailed():
              Navigator.pushNamed(context, '/login');
            case AuthSucess():
              Navigator.pushNamed(context, '/home');
            default:
          }
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: neutral06,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/color.png'),
              SizedBox(
                height: 16,
              ),
              Text('Tunggu Sebentar'),
              SizedBox(
                height: 16,
              ),
              CircularProgressIndicator(
                color: primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
