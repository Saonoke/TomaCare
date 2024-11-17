import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomacare/presentation/auth/bloc/auth_bloc.dart';

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
          state is AuthFailed
              ? Navigator.pushNamed(context, '/login')
              : Navigator.pushNamed(context, '/home');
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('loading'),
      ),
    );
  }
}
