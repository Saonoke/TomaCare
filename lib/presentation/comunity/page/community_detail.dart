import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomacare/presentation/comunity/bloc/comunity_bloc.dart';
import 'package:tomacare/presentation/comunity/page/comunity_edit.dart';
import 'package:tomacare/presentation/misc/constant/app_constant.dart';
import 'package:tomacare/presentation/user/bloc/profile_bloc.dart';
import 'package:tomacare/presentation/user/bloc/profile_event.dart';
import 'package:tomacare/service/save_auth.dart';

class PostDetailPage extends StatefulWidget {
  final int postId;

  // Constructor to accept the postId
  const PostDetailPage({Key? key, required this.postId}) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final SaveAuth saveService = SaveAuth();
  late Future<int> _userIdFuture;

  @override
  void initState() {
    super.initState();
    _userIdFuture = _getUserId();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f8f4),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => ComunityBloc()..add(OpenPost(widget.postId)),
          child: FutureBuilder<int>(
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
                  create: (context) =>
                      ProfileBloc()..add(MyComunityStarted(userId)),
                  child: PostDetailView(
                    currentUserId: userId,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class PostDetailView extends StatefulWidget {
  final int currentUserId;

  // Constructor to accept the postId
  const PostDetailView({Key? key, required this.currentUserId})
      : super(key: key);

  @override
  State<PostDetailView> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<PostDetailView> {
  final TextEditingController _commentController = TextEditingController();

  bool showAllComments = false;
  // Toggle untuk Read More
  void _addComment(int postId, String comment) {
    context.read<ComunityBloc>().add(Comment(postId, comment));
    _commentController.clear();
  }

  void _deleteComment(int postId, int commentId) {
    context.read<ComunityBloc>().add(RemoveComment(postId, commentId));
  }

  void _deletePost(int postId) {
    context.read<ComunityBloc>().add(DeletePost(postId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ComunityBloc, ComunityState>(
      listener: (context, state) {},
      child: BlocBuilder<ComunityBloc, ComunityState>(
        builder: (context, state) {
          if (state is DeletePostSuccess) {
            Navigator.pop(
              context,
            );
          }
          if (state is ComunityPostLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ComunityPostFailed) {
            return Center(child: Text(state.error));
          }
          if (state is ComunityPostLoaded) {
            return Scaffold(
              backgroundColor: neutral06,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Stack(
                            children: [
                              Image.network(
                                state.post['image_url'],
                                height: 250,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      state.post['user']['profile_img']),
                                  radius: 30,
                                  backgroundColor: neutral06,
                                ),
                              ),
                              Positioned(
                                top: 10,
                                left: 10,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              if (state.post['user']['id'] ==
                                  widget.currentUserId)
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: PopupMenuButton<String>(
                                    menuPadding: EdgeInsets.zero,
                                    icon: const Icon(
                                      Icons.more_vert, // Ellipsis icon
                                      color: Colors.white,
                                    ),
                                    color: Colors.white,
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditCommunitypage(
                                                      postId: state.post['id'],
                                                    ))).then(
                                          (value) {
                                            context.read<ComunityBloc>().add(
                                                OpenPost(state.post['id']));
                                          },
                                        );
                                      } else if (value == 'delete') {
                                        _deletePost(state.post['id']);
                                      }
                                    },
                                    itemBuilder: (BuildContext context) => [
                                      const PopupMenuItem<String>(
                                        value: 'edit',
                                        child: Text('Edit'),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Post Title and Author
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.post['title'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'by @${state.post['user']['username']}',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Post Body
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              state.post['body'],
                              style: const TextStyle(fontSize: 16, height: 1.5),
                            ),
                          ),
                          const SizedBox(height: 20),

                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white, // Warna latar belakang
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(
                                    20.0), // Sudut melengkung di kiri atas
                                topRight: Radius.circular(
                                    20.0), // Sudut melengkung di kanan atas
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.04), // Warna bayangan
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(
                                      0, -10), // Posisi bayangan hanya ke atas
                                ),
                              ],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(16.0), // Content padding
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Comments",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[800]),
                                  ),
                                  Divider(),
                                  const SizedBox(height: 10),
                                  // Display Comments
                                  ...state.post['comments']
                                      .take(showAllComments
                                          ? state.post['comments'].length
                                          : 2)
                                      .map<Widget>((comment) {
                                    final bool isCurrentUser = comment['user']
                                            ['id'] ==
                                        widget.currentUserId;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Foto profil
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                comment['user']['profile_img']),
                                          ),
                                          const SizedBox(width: 10),
                                          // Teks komentar
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  comment['user']['username'],
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(comment['commentary']),
                                                const SizedBox(height: 1),
                                                Text(
                                                  comment['timestamp'],
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Tombol tindakan (opsional)
                                          if (isCurrentUser)
                                            PopupMenuButton<String>(
                                              menuPadding: EdgeInsets.zero,
                                              icon: const Icon(
                                                Icons
                                                    .more_vert, // Ikon ellipsis
                                                color: Colors
                                                    .black, // Sesuaikan warna dengan tema UI
                                              ),
                                              onSelected: (value) {
                                                if (value == 'delete') {
                                                  _deleteComment(
                                                      state.post['id'],
                                                      comment['id']);
                                                }
                                              },
                                              itemBuilder:
                                                  (BuildContext context) => [
                                                PopupMenuItem<String>(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: [
                                                      const Text('Delete'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  if (!showAllComments &&
                                      state.post['comments'].length > 2)
                                    Center(
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            showAllComments = true;
                                          });
                                        },
                                        child: const Text('Read More'),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              hintText: 'Add a comment...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send, color: Colors.green[700]),
                          onPressed: () {
                            if (_commentController.text.isNotEmpty) {
                              _addComment(
                                  state.post['id'], _commentController.text);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No data available.'));
        },
      ),

    );
  }
}
