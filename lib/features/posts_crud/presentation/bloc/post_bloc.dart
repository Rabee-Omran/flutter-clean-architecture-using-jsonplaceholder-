import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/strings/failures.dart';
import '../../../../core/strings/messages.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/add_post.dart';
import '../../domain/usecases/delete_post.dart';
import '../../domain/usecases/get_all_posts.dart';
import '../../domain/usecases/get_post_detail.dart';
import '../../domain/usecases/update_post.dart';
part 'post_event.dart';
part 'post_state.dart';

enum Action { UPDATED, DELETED, ADDED }

class PostBloc extends Bloc<PostEvent, PostState> {
  final AddPost addPost;
  final DeletePost deletePost;
  final GetAllPosts getAllPosts;
  final GetPostDetail getPostDetail;
  final UpdatePost updatePost;
  final NetworkInfo networkInfo;

  PostBloc({
    required this.addPost,
    required this.deletePost,
    required this.getAllPosts,
    required this.getPostDetail,
    required this.updatePost,
    required this.networkInfo,
  }) : super(InitialState()) {
    on<PostEvent>((event, emit) async {
      if (event is GetAllPostsEvent) {
        _mapPostToState(state);
      } else if (event is PostsRefreshEvent) {
        emit(InitialState());
        _mapPostToState(state);
      } else if (event is GetPostDetailEvent) {
        emit(LoadingState());
        final failureOrPost = await getPostDetail(
          Params(id: event.postId),
        );

        emit(failureOrPost.fold(
          (failure) => ErrorState(message: _mapFailureToMessage(failure)),
          (post) => LoadedPostDetailState(post: post),
        ));
      } else if (event is UpdatePostEvent) {
        emit(LoadingState());
        final failureOrDoneMessage = await updatePost(
          event.post,
        );
        emit(_eitherDoneMessageOrErrorState(
            failureOrDoneMessage, UPDATE_SUSCESS_MESSAGE));
      } else if (event is DeletePostEvent) {
        emit(LoadingState());
        final failureOrDoneMessage = await deletePost(
          Params(id: event.postId),
        );
        emit(_eitherDoneMessageOrErrorState(
            failureOrDoneMessage, DELETE_SUSCESS_MESSAGE));
      } else if (event is AddPostEvent) {
        emit(LoadingState());
        final failureOrDoneMessage = await addPost(
          event.post,
        );
        emit(_eitherDoneMessageOrErrorState(
            failureOrDoneMessage, ADD_SUSCESS_MESSAGE));
      } else {
        emit(InitialState());
      }
    });
  }
  Future<void> _mapPostToState(PostState state) async {
    bool isConnected = await networkInfo.isConnected;
    if (state is InitialState) {
      emit(LoadingState());
      final failureOrPosts = await getAllPosts(
        PaginationParams(start: 0, limit: 20),
      );
      emit(failureOrPosts.fold(
        (failure) => ErrorState(message: _mapFailureToMessage(failure)),
        (posts) => LoadedPostsState(
            posts: posts, hasReachedMax: isConnected ? false : true),
      ));
      return;
    }
    if (!isConnected) {
      return;
    }

    LoadedPostsState postLoaded = state as LoadedPostsState;

    final failureOrPosts = await getAllPosts(
      PaginationParams(start: postLoaded.posts.length, limit: 20),
    );

    emit(failureOrPosts.fold(
        (failure) => ErrorState(message: _mapFailureToMessage(failure)),
        (posts) => posts.isEmpty
            ? postLoaded.copyWith(hasReachedMax: true)
            : postLoaded.copyWith(posts: postLoaded.posts + posts)));
  }
}

PostState _eitherDoneMessageOrErrorState(
    Either<Failure, bool> either, String message) {
  return either.fold(
    (failure) => ErrorState(message: _mapFailureToMessage(failure)),
    (isDone) => MessageState(message: message),
  );
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case CacheFailure:
      return CACHE_FAILURE_MESSAGE;
    case OfflineFailure:
      return OFFLINE_FAILURE_MESSAGE;
    default:
      return 'Unexpected Error, Please try again later .';
  }
}
