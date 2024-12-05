import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tomacare/presentation/misc/constant/app_constant.dart';
import 'package:tomacare/presentation/user/bloc/profile_bloc.dart';
import 'package:tomacare/presentation/user/bloc/profile_event.dart';
import 'package:tomacare/presentation/user/bloc/profile_state.dart';
import 'package:tomacare/presentation/user/page/change_password.dart';
import 'package:tomacare/presentation/user/page/create_password.dart';
import 'package:tomacare/presentation/user/page/profile_page.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(LoadPersonalMenu()),
      child: Scaffold(
        backgroundColor: const Color(0xfff2f8f4),
        appBar: AppBar(
          backgroundColor: const Color(0xfff2f8f4),
          title: Text('Personal Settings'),
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is PersonalMenuLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is PersonalMenuLoaded) {
              print(state.user);
              return ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  UserProfileWidget(
                    name: state.user['full_name'],
                    email: state.user['email'],
                    imageUrl: state.user['profile_img'],
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: Icon(Icons.person, color: neutral02),
                    title: Text(
                      'Change Profile',
                      style: TextStyle(color: neutral01),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                  ),
                  Divider(),
                  state.user['hasPassword']
                      ? ListTile(
                          leading: Icon(Icons.lock, color: neutral02),
                          title: Text(
                            'Change Password',
                            style: TextStyle(color: neutral01),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // Navigasi ke halaman Change Password
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangePasswordPage()),
                            );
                          },
                        )
                      : ListTile(
                          leading: Icon(Icons.lock, color: neutral02),
                          title: Text(
                            'Create Password',
                            style: TextStyle(color: neutral01),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // Navigasi ke halaman Change Password
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreatePasswordPage()),
                            );
                          },
                        )
                ],
              );
            }
            return const SizedBox.shrink(); // Default empty state
          },
        ),
      ),
    );
  }
}

class UserProfileWidget extends StatelessWidget {
  final String name;
  final String email;
  final String? imageUrl;

  const UserProfileWidget(
      {Key? key,
      required this.name,
      required this.email,
      required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: neutral03,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Profile Picture
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: imageUrl != null
                ? NetworkImage(imageUrl!)
                : null,
            child: imageUrl == null
                ? Icon(Icons.person, size: 50, color: Colors.grey.shade700)
                : null,
          ),
          const SizedBox(width: 16),
          // User Information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: neutral02,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 14,
                    color: neutral02,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
