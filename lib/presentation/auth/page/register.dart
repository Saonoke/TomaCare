import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomacare/presentation/auth/bloc/auth_bloc.dart';
import 'package:tomacare/presentation/auth/page/login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fancy_password_field/fancy_password_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordValidationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f8f4),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(36),
            child: Column(
              children: [
                const SizedBox(
                  height: 43,
                ),
                appBar(),
                registerForm()
              ],
            )),
      ),
    );
  }

  Widget appBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, // Menempatkan ikon di kiri
      children: [
        IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        const Expanded(
          child: Text(
            'Register',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          width: 40,
        )
      ],
    );
  }

  Widget registerForm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            formLabel('Enter your email'),
            formField(emailController, 'Email'),
            const SizedBox(
              height: 20,
            ),
            formLabel('Enter your fullname'),
            formField(fullNameController, 'Fullname'),
            const SizedBox(
              height: 20,
            ),
            formLabel('Enter your username'),
            formField(usernameController, 'Username'),
            const SizedBox(
              height: 20,
            ),
            formLabel('Enter your Password'),
            formField(passwordController, 'Password', isPassword: true),
            const SizedBox(
              height: 20,
            ),
            formLabel('Verify your Password'),
            formField(passwordValidationController, 'Verify Password',
                isPassword: true),
          ],
        ),
      ),
      const SizedBox(
        height: 40,
      ),
      submitButton()
    ]);
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

  Widget formField(TextEditingController controller, String hintText,
      {isPassword = false}) {
    final valRuleFullName = {
      MinCharactersValidationRule(3),
      MaxCharactersValidationRule(100),
    };
    final valRuleUsername = {
      MinCharactersValidationRule(3),
      MaxCharactersValidationRule(50)
    };

    if (!isPassword) {
      return SizedBox(
        // height: 48 + 22,
        width: 312,
        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$hintText is required!';
            }

            if (hintText == 'Email') {
              if (!EmailValidator.validate(value)) {
                return 'Invalid email!';
              }
            }

            if (hintText == 'Fullname') {
              for (var rule in valRuleFullName) {
                if (!rule.validate(value)) {
                  return rule.name;
                }
              }
            }

            if (hintText == 'Username') {
              for (var rule in valRuleUsername) {
                if (!rule.validate(value)) {
                  return rule.name;
                }
              }
            }

            return null;
          },
          controller: controller,
          decoration: InputDecoration(
              labelText: hintText,
              labelStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w300,
                height: 22 / 12,
                letterSpacing: -0.408,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 29.0, vertical: 13),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1000))),
        ),
      );
    } else {
      if (hintText == 'Verify Password') {
        return password(
          controller: controller,
          label: hintText,
          isLogin: true,
        );
      }
      return password(
        controller: controller,
        label: hintText,
        isLogin: false,
      );
    }
  }

  Widget submitButton() {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Center(
          child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<AuthBloc>().add(Register(
                      emailController.text,
                      fullNameController.text,
                      usernameController.text,
                      passwordController.text));
                  
                }
              },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Color(0xff27AE61)),
                fixedSize: WidgetStatePropertyAll(Size(312, 48)),
              ),
              child: const Text(
                'Register',
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
    );
  }
}
