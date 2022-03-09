import 'package:dartz/dartz.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/posts_crud_repository.dart';
import '../datasources/post_crud_local_data_source.dart';
import '../datasources/post_crud_remote_data_source.dart';
import '../models/post_model.dart';

typedef Future<bool> _DeletedAddedUpdatedChooser();

class PostsCrudRepositoryImpl implements PostsCrudRepository {
  final PostCrudRemoteDataSource remoteDataSource;
  final PostCrudLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PostsCrudRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, List<Post>>> getAllPosts(
      {required int start, required int limit}) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts =
            await remoteDataSource.getAllPosts(start: start, limit: limit);
        List<PostModel> postsModel = [];
        if (remotePosts.length > 20) {
          postsModel = _convertPostToPostModel(20, remotePosts);
        } else {
          postsModel = _convertPostToPostModel(remotePosts.length, remotePosts);
        }

        localDataSource.cacheLast20Posts(postsModel);
        return Right(remotePosts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPosts = await localDataSource.getLast20Posts();
        return Right(localPosts);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Post>> getPostDetail(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePost = await remoteDataSource.getPostDetail(id);

        return Right(remotePost);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  List<PostModel> _convertPostToPostModel(int length, List<Post> remotePosts) {
    List<PostModel> postsModel = [];
    for (var i = 0; i < length; i++) {
      postsModel.add(PostModel(
          id: remotePosts[i].id,
          title: remotePosts[i].title,
          body: remotePosts[i].body));
    }

    return postsModel;
  }

  @override
  Future<Either<Failure, bool>> addPost(Post post) async {
    return await _getMessage(() {
      return remoteDataSource.addPost(post);
    });
  }

  @override
  Future<Either<Failure, bool>> deletePost(int id) async {
    return await _getMessage(() {
      return remoteDataSource.deletePost(id);
    });
  }

  @override
  Future<Either<Failure, bool>> updatePost(Post post) async {
    return await _getMessage(() {
      return remoteDataSource.updatePost(post);
    });
  }

  Future<Either<Failure, bool>> _getMessage(
    _DeletedAddedUpdatedChooser deletedAddedUpdatedChooser,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final isDone = await deletedAddedUpdatedChooser();

        return Right(isDone);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
