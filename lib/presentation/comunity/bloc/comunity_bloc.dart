import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:tomacare/service/cloudinary.dart';
import 'package:tomacare/service/comunity_service.dart';

part 'comunity_event.dart';
part 'comunity_state.dart';

class ComunityBloc extends Bloc<ComunityEvent, ComunityState> {
  final ComunityService comunityService = ComunityService();
  final Cloudinary cloudinary = Cloudinary();

  ComunityBloc() : super(ComunityInitial()) {
    on<ComunityStarted>((event, emit) async {
      emit(ComunityLoading());
      try {
        final posts = await comunityService.getAll();
        emit(ComunityLoaded(posts));
      } catch (e) {
        emit(ComunityError(e.toString()));
      }
    });

    on<OpenPost>((event, emit) async {
      emit(ComunityPostLoading());
      try {
        final post = await comunityService.getById(event.postId);

        emit(ComunityPostLoaded(post));
      } catch (e) {
        emit(ComunityPostFailed(e.toString()));
      }
    });

    on<Comment>((event, emit) async {
      emit(ComunityPostLoading());
      try {
        final post =
            await comunityService.postComment(event.postId, event.comment);

        emit(ComunityPostLoaded(post));
      } catch (e) {
        emit(ComunityPostFailed(e.toString()));
      }
    });

    on<RemoveComment>((event, emit) async {
      emit(ComunityPostLoading());
      try {
        final post =
            await comunityService.removeComment(event.postId, event.commentId);

        emit(ComunityPostLoaded(post));
      } catch (e) {
        emit(ComunityPostFailed(e.toString()));
      }
    });

    on<CreatePost>((event, emit) async {
      final Map<String, dynamic> imagesUploaded =
          await Cloudinary().upload(event.imagePath);
      emit(ComunityLoading());
      try {
        final post = await comunityService.createPost(
            title: event.title,
            body: event.body,
            imagePath: imagesUploaded['url']);
        emit(ComunityPostLoaded(post));
      } catch (e) {
        emit(ComunityError(e.toString()));
      }
    });

    on<PostReaction>((event, emit) async {
      if (state is ComunityLoaded) {

        final currentState = state as ComunityLoaded;
        try {
          final react =
              await comunityService.reaction(event.postId, event.reactionType);
          if (react) {
            currentState.posts.map((post) {
              if (post['id'] == event.postId) {
                return {
                  ...post,
                  'liked': event.reactionType == 'Like',
                  'disliked': event.reactionType == 'Dislike',
                };
              }
              return post;
            }).toList();
            final posts = await comunityService.getAll();
            emit(ComunityLoaded(posts));

          } else {
            emit(ComunityReactionFailed());
          }
        } catch (e) {
          emit(ComunityError(e.toString()));
        }
      }
    });

    on<SearchComunity>((event, emit) async {
      emit(ComunityLoading());
      try {
        final posts = await comunityService.getAll(event.searchQuery);
        emit(ComunityLoaded(posts));
      } catch (e) {
        emit(ComunityError(e.toString()));
      }
    });

    on<DeletePost>((event, emit) async {
      emit(ComunityPostLoading());
      try {
        final res = await comunityService.removePost(event.postId);
        if (res['success']) {
          emit(DeletePostSuccess());
          return;
        }
        emit(ComunityPostFailed('Delete Failed!'));
      } catch (e) {
        emit(ComunityPostFailed(e.toString()));
      }
    });

    on<EditPost>((event, emit) async {
      emit(EditPostLoading());
      try {
        final post = await comunityService.getById(event.postId);

        emit(EditPostLoaded(post));
      } catch (e) {
        emit(EditPostFailed(e.toString()));
      }
    });

    on<EditPostAction>((event, emit) async {
      emit(EditPostLoading());
      try {
        await comunityService.editPost(event.postId, event.title, event.body);

        emit(EditPostSuccess());
      } catch (e) {
        emit(EditPostFailed(e.toString()));
      }
    });
  }
}
