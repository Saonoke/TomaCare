import 'package:flutter/material.dart';
import 'package:tomacare/page/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordValidationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f8f4),
      body: Container(
          // margin: const EdgeInsets.only(left: 36, top: 8, right: 36, bottom: 8),
          padding: EdgeInsets.all(36),
          child: Column(
            children: [
              SizedBox(
                height: 43,
              ),
              appBar(),
              registerForm()
            ],
          )),
    );
  }

  Widget appBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, // Menempatkan ikon di kiri
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24,
          ),
          onPressed: () {
            // Logika untuk kembali ke halaman sebelumnya
            Navigator.pop(context);
          },
        ),
        Expanded(
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
        SizedBox(
          width: 40,
        )
      ],
    );
  }

  Widget registerForm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center , children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            formLabel('Enter your email'),
            formField(emailController, 'Email'),

            const SizedBox(
              height: 30,
            ),
            formLabel('Enter your fullname'),
            formField(fullNameController, 'Fullname'),

            const SizedBox(
              height: 30,
            ),
            formLabel('Enter your username'),
            formField(usernameController, 'Username'),

            const SizedBox(
              height: 30,
            ),
            formLabel('Enter your Password'),
            formField(passwordController, 'Password', isPassword: true),

            const SizedBox(
              height: 30,
            ),
            formLabel('Verify your Password'),
            formField(passwordValidationController, 'Password', isPassword: true),
          ],
        ),

      const SizedBox(
        height: 50,
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

  Widget formField(TextEditingController controller, String hintText, {isPassword = false}) {
    if (!isPassword){
      return SizedBox(
        height: 48,
        width: 312,
        child: TextField(
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
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(1000))),
        ),
      );
    } else {
      return password();
    }
  }

  Widget submitButton(){
    return Center(
      child: ElevatedButton(
          onPressed: () {},
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
  }
}
