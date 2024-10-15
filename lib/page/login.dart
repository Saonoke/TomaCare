import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f8f4),
      body: Container(
        margin: const EdgeInsets.only(left: 36, top: 8, right: 36, bottom: 8),
        child: Column(
          children: [
            header(context),
            const SizedBox(
              height: 30,
            ),
            inputField(context),
            const SizedBox(
              height: 59,
            ),
            footer(context),
          ],
        ),
      ),
    );
  }
}

header(context) {
  return const Column(
    children: [
      SizedBox(
        child: Center(child: Text('Logo')),
        height: 255,
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

inputField(context) {
  return Column(
    // crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10),
            margin: EdgeInsets.only(bottom: 11),
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
            height: 48,
            width: 312,
            child: TextField(
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
        height: 32,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10),
            margin: EdgeInsets.only(bottom: 11),
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
          password(),
        ],
      ),
      const SizedBox(
        height: 38,
      ),
      Center(
        child: ElevatedButton(
            onPressed: () {},
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
      ),
      const SizedBox(
        height: 40,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
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
            child: Text(
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

class password extends StatefulWidget {
  const password({
    super.key,
  });

  @override
  State<password> createState() => _passwordState();
}

class _passwordState extends State<password> {
  bool _obscureText = true; // Menyimpan status visibility password

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText; // Mengubah status visibility
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: 312,
      child: TextField(
        obscureText: _obscureText,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: _togglePasswordVisibility, // Mengubah visibility saat ikon ditekan
          ),
          hintText: 'Password',
          labelText: 'Password',
          labelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w300,
            height: 22 / 12,
            letterSpacing: -0.408,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 29.0, vertical: 13,
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
      Text(
        'Or',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 17,
          fontWeight: FontWeight.w700,
          height: 22 / 17,
          letterSpacing: -0.408,
        ),
      ),
      SizedBox(
        height: 11,
      ),
      SizedBox(
        height: 48,
        width: 312,
        child: ElevatedButton(
          onPressed: () {

          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Colors.white), // Warna latar belakang putih
            elevation: MaterialStateProperty.all<double>(2), // Elevasi tombol
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1000), // Sudut tombol
                side: BorderSide(color: Colors.grey.shade300), // Garis pinggir
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://s3-alpha-sig.figma.com/img/0e8c/5336/ec40b19b6983a179020e0e933a042d6b?Expires=1730073600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=gFSHSh7xi2ah8QPOVIo6XTa15cwoCBDwohSjmPhSMmwCOUi2D2fCznUog1Ox3oSY2WxJ2ZTnbGHybkuPfLEbPet0kyMGd7Q40fd97pp~EMhcCGs8YWUdw54ZIsWYHfWTZoHLLOSzl8RtcIpQQop0WGrS-0sFPhZv1sF-lYkjwsZ67fdIVkTDBFc94YHCw-jL~ZIgW8w4fiJKbc9VSvFwiT8UclYjL~2-oMzTo2o6AyITmBCSHHH3H6UgoDbLgH~g-~Zw-KAaM-H37gYhZhK-IS~~i9GL1vEoje-1fxB3gYzpAM~bKJXK27vf8oASx61rxzc4aCYZj-TUL4cDOrRvcQ__',
                width: 24,
                height: 24,
              ),
              SizedBox(width: 8),
              Text(
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
