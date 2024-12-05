import 'package:flutter/material.dart';
import 'package:tomacare/presentation/auth/page/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomacare/presentation/user/bloc/profile_bloc.dart';
import 'package:tomacare/presentation/user/bloc/profile_event.dart';
import 'package:tomacare/presentation/user/bloc/profile_state.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Change Password'),
          backgroundColor: const Color(0xfff2f8f4),
          elevation: 0,
        ),
        backgroundColor: const Color(0xfff2f8f4),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is PasswordSuccess) {
              Navigator.pop(
                context,
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    formLabel('Enter your New Password'),
                    passwordField(
                      controller: newPasswordController,
                      hintText: 'Enter new password',
                    ),
                    const SizedBox(height: 20),
                    formLabel('Enter your Old Password'),
                    passwordField(
                        controller: oldPasswordController,
                        hintText: 'Enter old password',
                        isOld: true),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<ProfileBloc>().add(ChangePassword(
                                  oldPassword: oldPasswordController.text,
                                  newPassword: newPasswordController.text));
                            }
                            if (state is PasswordSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Password updated!')),
                              );
                            }
                            if (state is PasswordError) {
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(
                              //       content: Text(state.error)),
                              // );
                            }
                          },
                          style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Color(0xff27AE61)),
                            fixedSize: WidgetStatePropertyAll(Size(312, 48)),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                height: 22 / 17,
                                letterSpacing: -0.408),
                          )),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget formLabel(String label) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      margin: const EdgeInsets.only(bottom: 11),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 20 / 14,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget passwordField(
      {required TextEditingController controller,
      required String hintText,
      bool isOld = false}) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: hintText,
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w300,
          height: 22 / 12,
          letterSpacing: -0.408,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 29.0,
          vertical: 13.0,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1000),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1000),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1000),
          borderSide: const BorderSide(color: Color(0xff2c786c)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$hintText is required';
        } else if (value.length < 6) {
          if (!isOld) {
            return 'Password must be at least 6 characters long';
          } else {
            return null;
          }
        }
        return null;
      },
    );
  }
}
