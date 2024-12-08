import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomacare/domain/entities/post.dart';
import 'package:tomacare/presentation/auth/bloc/auth_bloc.dart';
import 'package:tomacare/presentation/comunity/page/community_page.dart';
import 'package:tomacare/presentation/misc/constant/app_constant.dart';
import 'package:tomacare/presentation/user/bloc/profile_bloc.dart';
import 'package:tomacare/presentation/user/bloc/profile_event.dart';
import 'package:tomacare/presentation/user/bloc/profile_state.dart';
import 'package:tomacare/service/save_auth.dart';

class MyComunity extends StatefulWidget {
  const MyComunity({super.key});

  @override
  State<MyComunity> createState() => _MyComunityState();
}

class _MyComunityState extends State<MyComunity> {
  final SaveAuth saveService = SaveAuth();
  late Future<int> _userIdFuture;

  @override
  void initState() {
    super.initState();
    _userIdFuture = _getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Community Posts'),
        backgroundColor: neutral06,
      ),
      body: FutureBuilder<int>(
        future: _userIdFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final userId = snapshot.data!;
            return BlocProvider(
              create: (context) => ProfileBloc()..add(MyComunityStarted(userId)),
              child: MyComunityPage(),
            );
          }
        },
      ),
    );
  }

  Future<int> _getUserId() async {
    final String? token = await saveService.getToken();
    if (token == null) {
      throw Exception("Token is null");
    }

    try {
      String normalizedSource = base64Url.normalize(token.split('.')[1]);
      final res = jsonDecode(utf8.decode(base64Url.decode(normalizedSource)));
      return res['id'];
    } catch (e) {
      throw Exception("Failed to parse user ID from token: $e");
    }
  }
}


class MyComunityPage extends StatefulWidget {
  const MyComunityPage({super.key});

  @override
  State<MyComunityPage> createState() => _MyComunityPage();
}

class _MyComunityPage extends State<MyComunityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: neutral06,
        body: SafeArea(
            child: Column(children: [
          Expanded(
              child: BlocListener<ProfileBloc, ProfileState>(
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
                if (state is MyComunityLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MyComunityLoaded) {
                  if (state.posts.isEmpty) {
                    return const Center(
                      child: Text(
                        'No posts found',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.posts.length,
                    itemBuilder: (context, index) {
                      final post = Post.fromJson(state.posts[index]);
                      return PostCard(
                        postId: post.id ?? -1,
                        username: post.user.fullName,
                        date: '1 hari',
                        title: post.title ?? '',
                        image: post.image,
                        profileImg: post.user.profileImg,
                        commentLength: state.posts[index]['comments'].length,
                        isDisliked: post.disliked,
                        isLiked: post.liked,
                      );
                    },
                  );
                } else if (state is MyComunityError) {
                  if (state.error == 'Exception: Token has expired.') {
                    context.read<AuthBloc>().add(Logout());
                  }
                  return Center(
                    child: Text(
                      state.error,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink(); // Default empty state
              },
            ),
          )),
        ])));
  }
}
