import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomacare/domain/entities/post.dart';
import 'package:tomacare/presentation/auth/bloc/auth_bloc.dart';
import 'package:tomacare/presentation/comunity/bloc/comunity_bloc.dart';
import 'package:tomacare/presentation/comunity/page/community_detail.dart';
import 'package:tomacare/presentation/misc/constant/app_constant.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ComunityBloc(),
      child: CommunityPageList(),
    );
  }
}

class CommunityPageList extends StatefulWidget {
  const CommunityPageList({super.key});
  @override
  State<CommunityPageList> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPageList> {
  @override
  void initState() {
    context.read<ComunityBloc>().add(ComunityStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: neutral06,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        context
                            .read<ComunityBloc>()
                            .add(SearchComunity(value.toString()));
                      },
                      decoration: InputDecoration(
                        hintText: 'Cari di komunitas',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<ComunityBloc, ComunityState>(
                builder: (context, state) {
                  if (state is ComunityLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ComunityLoaded) {
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
                  } else if (state is ComunityError) {
                    if (state.message == 'Exception: Token has expired.') {
                      context.read<AuthBloc>().add(Logout());
                    }
                    return Center(
                      child: Text(
                        state.message,
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
            ),
          ],
        ),
      ),
    );
  }
}

class PostCard extends StatefulWidget {
  final int postId;
  final String username;
  final String date;
  final String title;
  final String image;
  final String profileImg;
  final int commentLength;
  bool isLiked = false;
  bool isDisliked = false;

  PostCard({
    required this.postId,
    required this.username,
    required this.date,
    required this.title,
    required this.image,
    required this.profileImg,
    required this.commentLength,
    required this.isLiked,
    required this.isDisliked,
    super.key,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  void toggleLike() {
    context.read<ComunityBloc>().add(PostReaction(widget.postId, 'Like'));
    setState(() {
      widget.isLiked = !widget.isLiked;
      if (widget.isLiked)
        widget.isDisliked = false; // Dislike is deactivated if Like is pressed
    });
  }

  void toggleDislike() {
    context.read<ComunityBloc>().add(PostReaction(widget.postId, 'Dislike'));
    setState(() {
      widget.isDisliked = !widget.isDisliked;
      if (widget.isDisliked)
        widget.isLiked = false; // Like is deactivated if Dislike is pressed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostDetailPage(
                        postId: widget.postId,
                      )));
        },
        child: Card(
          color: neutral06,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post image
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  widget.image, // Replace with actual image URL
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              // Post content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: NetworkImage(widget.profileImg),
                      onBackgroundImageError: (_, __) {},
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.username,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            widget.date,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.title,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                color: neutral03,
              ),
              // Post actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            widget.isLiked
                                ? Icons.thumb_up_alt
                                : Icons.thumb_up_alt_outlined,
                            color: widget.isLiked ? Colors.blue : Colors.grey,
                          ),
                          onPressed: toggleLike,
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(
                            widget.isDisliked
                                ? Icons.thumb_down_alt
                                : Icons.thumb_down_alt_outlined,
                            color: widget.isDisliked ? Colors.red : Colors.grey,
                          ),
                          onPressed: toggleDislike,
                        ),
                      ],
                    ),
                    Text(
                      '${widget.commentLength} Jawaban',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
