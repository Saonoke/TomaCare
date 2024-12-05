import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tomacare/service/comunity_service.dart';

part 'comunity_event.dart';
part 'comunity_state.dart';

class ComunityBloc extends Bloc<ComunityEvent, ComunityState> {
  final ComunityService comunityService = ComunityService();

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
      emit(ComunityLoading());
      try {
        final post = await comunityService.getById(event.postId);
        emit(ComunityPostLoaded(post));
      } catch (e) {
        emit(ComunityError(e.toString()));
      }
    });

    on<PostReaction>((event, emit) async {
      if (state is ComunityLoaded) {
        final currentState = state as ComunityLoaded;
        try {
          final react = await comunityService.reaction(event.postId, event.reactionType);
          if (react) {
            // Update the specific post's reaction in the list
            final updatedPosts = currentState.posts.map((post) {
              if (post['id'] == event.postId) {
                return {
                  ...post,
                  'liked': event.reactionType == 'Like',
                  'disliked': event.reactionType == 'Dislike',
                };
              }
              return post;
            }).toList();

            emit(ComunityLoaded(updatedPosts));
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
  }
}
