import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tomacare/domain/entities/user.dart';
import 'package:tomacare/presentation/user/bloc/profile_bloc.dart';
import 'package:tomacare/presentation/user/bloc/profile_event.dart';
import 'package:tomacare/presentation/user/bloc/profile_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f8f4),
      ),
      backgroundColor: const Color(0xfff2f8f4),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => ProfileBloc()..add(LoadProfile()),
          child: const ProfileView(),
        ),
      ),
    );
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  String? fullName;
  String? username;
  String? email;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is ProfileLoaded && state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message!)),
          );
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final user = User.fromJson(state.user);

            return SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: _selectedImage != null
                              ? FileImage(File(_selectedImage!.path)) as ImageProvider
                              : (user.profileImg.isNotEmpty
                              ? NetworkImage(user.profileImg)
                              : null),
                          child: _selectedImage == null && user.profileImg.isEmpty
                              ? Icon(Icons.person, size: 50, color: Colors.grey.shade700)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: GestureDetector(
                            onTap: () async {
                              final pickedFile = await _picker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (pickedFile != null) {
                                setState(() {
                                  _selectedImage = XFile(pickedFile.path);
                                });
                              }
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
                    ProfileField(
                      label: 'Full Name',
                      initialValue: user.fullName,
                      onChanged: (value) => fullName = value,
                    ),
                    ProfileField(
                      label: 'Username',
                      initialValue: user.username,
                      onChanged: (value) => username = value,
                    ),
                    ProfileField(
                      label: 'Email',
                      initialValue: user.email,
                      onChanged: (value) => email = value,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ProfileBloc>().add(
                                UpdateProfile(
                                  fullName: fullName ?? user.fullName,
                                  username: username ?? user.username,
                                  email: email ?? user.email,
                                  profileImg:
                                      _selectedImage?.path ?? user.profileImg,
                                  updatedProfileImage: _selectedImage
                                ),
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Update Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is ProfileError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No data available.'));
        },
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final ValueChanged<String>? onChanged;

  const ProfileField({
    Key? key,
    required this.label,
    this.initialValue,
    this.onChanged,
  }) : super(key: key);

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
          TextFormField(
            initialValue: initialValue,
            onChanged: onChanged,
            decoration: InputDecoration(
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
