import 'package:flutter/material.dart';
import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tomacare/presentation/auth/bloc/auth_bloc.dart';
import 'package:tomacare/presentation/misc/constant/app_constant.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: neutral06,
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                header(context),
                const SizedBox(
                  height: 32,
                ),
                inputField(),
                footer(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  inputField() {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    focusColor: primaryColor,
                    labelText: 'Nama pengguna atau email',
                    labelStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      height: 22 / 12,
                      letterSpacing: -0.408,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 18),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000))),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            password(
              controller: passwordController,
              label: 'Kata sandi',
            ),
          ],
        ),
        const SizedBox(
          height: 32,
        ),
        BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Center(
              child: ElevatedButton(
                  onPressed: () {
                    print('start auth');
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthBloc>()
                        ..add(LoginRequest(
                            emailController.text, passwordController.text));
                    }
                  },
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Color(0xff27AE61)),
                    fixedSize:
                        WidgetStatePropertyAll(Size(double.maxFinite, 54)),
                  ),
                  child: state is AuthLoading
                      ? CircularProgressIndicator()
                      : const Text(
                          'Masuk',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              height: 22 / 17,
                              letterSpacing: -0.408),
                        )),
            );
          },
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}

header(context) {
  return Column(
    children: [
      SizedBox(
        child: Center(
            child: Image.asset(
          "images/color.png",
          height: 150,
          width: 300,
        )),
      ),
      Text(
        'Login to Your Account',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          height: 22 / 17,
          letterSpacing: -0.408,
        ),
      ),
    ],
  );
}

class password extends StatefulWidget {
  final TextEditingController controller;

  final bool isLogin;
  final String label;

  const password({
    super.key,
    required this.controller,
    required this.label,
    this.isLogin = true,
  });

  @override
  State<password> createState() => _passwordState();
}

class _passwordState extends State<password> {
  bool _obscureText = true; // Menyimpan status visibility password
  final rules = {
    DigitValidationRule(),
    UppercaseValidationRule(),
    SpecialCharacterValidationRule(),
    MinCharactersValidationRule(6),
  };

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText; // Mengubah status visibility
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: FancyPasswordField(
        validationRules: rules,
        validationRuleBuilder: (rules, value) {
          return const Wrap();
        },
        hasValidationRules: !widget.isLogin,
        hasStrengthIndicator: false,
        controller: widget.controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Password is required';
          }

          if (!widget.isLogin) {
            for (var rule in rules) {
              if (!rule.validate(value)) {
                return rule.name;
              }
            }
          }

          return null;
        },
        obscureText: _obscureText,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed:
                _togglePasswordVisibility, // Mengubah visibility saat ikon ditekan
          ),
          labelText: widget.label,
          labelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w300,
            height: 22 / 12,
            letterSpacing: -0.408,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(1000),
          ),
        ),
      ),
    );
  }
}

footer(context) {
  return Column(
    children: [
      const Text(
        'Atau',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 17,
          fontWeight: FontWeight.w700,
          height: 22 / 17,
          letterSpacing: -0.408,
        ),
      ),
      const SizedBox(
        height: 16,
      ),
      BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          return SizedBox(
            height: 52,
            width: double.maxFinite,
            child: ElevatedButton(
              onPressed: state is AuthLoading
                  ? null // Nonaktifkan tombol saat sedang loading
                  : () {
                      context.read<AuthBloc>().add(SignInWithGoogle());
                    },
              style: ButtonStyle(
                backgroundColor: const WidgetStatePropertyAll(neutral06),
                elevation: const WidgetStatePropertyAll(2),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1000),
                    side: BorderSide(color: neutral01),
                  ),
                ),
              ),
              child: state is AuthLoading
                  ? const CircularProgressIndicator(
                      color: Colors.black,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 8),
                        const Text(
                          'Masuk dengan Google',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Tidak punya akun ? ',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  height: 22 / 17,
                  letterSpacing: -0.408,
                  color: Color(0xff616362)),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text(
                'register',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  height: 22 / 17,
                  letterSpacing: -0.408,
                  color: Color(0xff27AE61),
                ),
              ),
            ),
          ],
        ),
      )
    ],
  );
}
