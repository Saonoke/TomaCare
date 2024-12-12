import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomacare/presentation/comunity/bloc/comunity_bloc.dart';

class CommunityDetailPage extends StatelessWidget {
  const CommunityDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ComunityBloc(),
      child: CommunityDetailScreen(),
    );
  }
}

class CommunityDetailScreen extends StatelessWidget {
  const CommunityDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<ComunityBloc, ComunityState>(
          builder: (context, state) {
            switch (state) {
              case ComunityInitial():
                context.watch<ComunityBloc>()..add(OpenPost(1));
                return CircularProgressIndicator();
              case ComunityPostLoaded():
                final post = state.post;

                final comments = post['comments'];
                final user = post['user'];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post['title']),
                    Text(post['body']),
                    Expanded(
                        child: ListView.builder(
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final comment = comments[index];
                              return Text(comment['commentary']);
                            }))
                  ],
                );
              default:
                return Text('error');
            }
          },
          listener: (context, state) {}),
    );
  }
}
