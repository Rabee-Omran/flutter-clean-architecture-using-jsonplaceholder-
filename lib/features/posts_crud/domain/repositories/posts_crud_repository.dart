import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/post.dart';

abstract class PostsCrudRepository {
  Future<Either<Failure, List<Post>>> getAllPosts(
      {required int start, required int limit});
  Future<Either<Failure, Post>> getPostDetail(int id);
  Future<Either<Failure, bool>> deletePost(int id);
  Future<Either<Failure, bool>> updatePost(Post post);
  Future<Either<Failure, bool>> addPost(Post post);
}
