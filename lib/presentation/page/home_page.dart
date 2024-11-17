import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomacare/presentation/auth/bloc/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<AuthBloc, AuthState>(
            builder: (context, state) {
              return Center(
                child: ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(Logout());
                    },
                    child: Text('logout')),
              );
            },
            listener: (context, state) {}),
      ),
    );
  }
}
