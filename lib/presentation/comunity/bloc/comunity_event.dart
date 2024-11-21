part of 'comunity_bloc.dart';

sealed class ComunityEvent extends Equatable {
  const ComunityEvent();

  @override
  List<Object> get props => [];
}

class ComunityStarted extends ComunityEvent {}

class OpenPost extends ComunityEvent {
  final int postId;

  const OpenPost(this.postId);

  @override
  List<Object> get props => [postId];
}

class CreatePost extends ComunityEvent {
  final String title;
  final String body;
  final String imagePath;

  const CreatePost(
      this.title,
      this.body,
      this.imagePath);

  @override
  List<Object> get props => [title, body, imagePath];
}

class EditPost extends ComunityEvent {
  final String title;
  final String body;
  final String imagePath;

  const EditPost(
      this.title,
      this.body,
      this.imagePath);

  @override
  List<Object> get props => [title, body, imagePath];
}

class PostReaction extends ComunityEvent {
  final int postId;
  final String reactionType;
  const PostReaction(
      this.postId,
      this.reactionType
      );
  @override
  List<Object> get props => [postId, reactionType];
}

class Comment extends ComunityEvent {
  final int postId;
  final String comment;

  const Comment(
      this.postId,
      this.comment
      );
  @override
  List<Object> get props => [postId, comment];
}