part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}


class InitialState extends PostState {}

class LoadingState extends PostState {}

class LoadedPostsState extends PostState {
  final List<Post> posts;

  LoadedPostsState({required this.posts});

  @override
  List<Object> get props => [posts];
}

class LoadedPostDetailState extends PostState {
  final Post post;

  LoadedPostDetailState({required this.post});

  @override
  List<Object> get props => [post];
}

class ErrorState extends PostState {
  final String message;

  ErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class MessageState extends PostState {
  final String message;

  MessageState({required this.message});

  @override
  List<Object> get props => [message];
}
