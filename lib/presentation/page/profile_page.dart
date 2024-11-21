import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f8f4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, bottom: 16.0, right: 16.0, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.grey.shade300,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          // Action for editing profile picture
                        },
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ProfileField(label: 'Full Name', value: 'Full Name'),
                ProfileField(label: 'Username', value: 'Username'),
                ProfileField(label: 'email', value: '@gmail.com'),
                ProfileField(label: 'Phone', value: 'No Phone'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final String value;

  ProfileField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: value,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide:
                    const BorderSide(color: Color.fromARGB(255, 235, 235, 235)),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
