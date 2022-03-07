part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent([List props = const <dynamic>[]]) : super();

  @override
  List<Object> get props => [props];
}

class GetAllPostsEvent extends PostEvent {}

class PostsRefreshEvent extends PostEvent {}

class GetPostDetailEvent extends PostEvent {
  final int postId;

  GetPostDetailEvent(this.postId) : super([postId]);
}

class UpdatePostEvent extends PostEvent {
  final Post post;

  UpdatePostEvent(this.post) : super([post]);
}

class DeletePostEvent extends PostEvent {
  final int postId;

  DeletePostEvent(this.postId) : super([postId]);
}

class AddPostEvent extends PostEvent {
  final Post post;

  AddPostEvent(this.post) : super([post]);
}
