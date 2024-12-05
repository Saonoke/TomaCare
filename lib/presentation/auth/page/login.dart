import 'package:flutter/material.dart';
import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tomacare/presentation/auth/bloc/auth_bloc.dart';

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
      backgroundColor: const Color(0xfff2f8f4),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            child: Column(
              children: [
                header(context),
                const SizedBox(
                  height: 30,
                ),
                inputField(),
                const SizedBox(
                  height: 59,
                ),
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
            Container(
              padding: const EdgeInsets.only(left: 10),
              margin: const EdgeInsets.only(bottom: 11),
              child: const Text(
                'Enter your email',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 20 / 14,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              // height: 48 + 32,
              width: 312,
              child: TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: 'Email',
                    labelText: 'Email',
                    labelStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      height: 22 / 12,
                      letterSpacing: -0.408,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 29.0, vertical: 13),
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
            Container(
              padding: const EdgeInsets.only(left: 10),
              margin: const EdgeInsets.only(bottom: 11),
              child: const Text(
                'Enter your password',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 20 / 14,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            password(
              controller: passwordController,
              label: 'Password',
            ),
          ],
        ),
        const SizedBox(
          height: 38,
        ),
        BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Center(
              child: ElevatedButton(
                  onPressed: () {
                    print('start auth');
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthBloc>().add(LoginRequest(
                          emailController.text, passwordController.text));
                    }
                  },
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Color(0xff27AE61)),
                    fixedSize: WidgetStatePropertyAll(Size(312, 48)),
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
          height: 40,
        ),
        Row(
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
        )
      ],
    );
  }
}

header(context) {
  return Column(
    children: [
      SizedBox(
        child: Center(child: Image.asset("images/color.png")),
        height: 150,
      ),
      Text(
        'Login to Your Account',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 17,
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
      width: 312,
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
            fontSize: 12,
            fontWeight: FontWeight.w300,
            height: 22 / 12,
            letterSpacing: -0.408,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 29.0,
            vertical: 13,
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
        'Or',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 17,
          fontWeight: FontWeight.w700,
          height: 22 / 17,
          letterSpacing: -0.408,
        ),
      ),
      const SizedBox(
        height: 11,
      ),
      BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          return SizedBox(
            height: 48,
            width: 312,
            child: ElevatedButton(
              onPressed: state is AuthLoading
                  ? null // Nonaktifkan tombol saat sedang loading
                  : () {
                      context.read<AuthBloc>().add(SignInWithGoogle());
                    },
              style: ButtonStyle(
                backgroundColor: const WidgetStatePropertyAll(Colors.white),
                elevation: const WidgetStatePropertyAll(2),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1000),
                    side: BorderSide(color: Colors.grey.shade300),
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
                          'Sign in with Google',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
      )
    ],
  );
}
