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
          listener: (context, state) {
            // TODO: implement listener
          },
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
                  child: const Text(
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
      SizedBox(
        height: 48,
        width: 312,
        child: ElevatedButton(
          onPressed: () {},
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.network(
              //   'https://s3-alpha-sig.figma.com/img/0e8c/5336/ec40b19b6983a179020e0e933a042d6b?Expires=1730073600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=gFSHSh7xi2ah8QPOVIo6XTa15cwoCBDwohSjmPhSMmwCOUi2D2fCznUog1Ox3oSY2WxJ2ZTnbGHybkuPfLEbPet0kyMGd7Q40fd97pp~EMhcCGs8YWUdw54ZIsWYHfWTZoHLLOSzl8RtcIpQQop0WGrS-0sFPhZv1sF-lYkjwsZ67fdIVkTDBFc94YHCw-jL~ZIgW8w4fiJKbc9VSvFwiT8UclYjL~2-oMzTo2o6AyITmBCSHHH3H6UgoDbLgH~g-~Zw-KAaM-H37gYhZhK-IS~~i9GL1vEoje-1fxB3gYzpAM~bKJXK27vf8oASx61rxzc4aCYZj-TUL4cDOrRvcQ__',
              //   width: 24,
              //   height: 24,
              // ),
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
      )
    ],
  );
}
