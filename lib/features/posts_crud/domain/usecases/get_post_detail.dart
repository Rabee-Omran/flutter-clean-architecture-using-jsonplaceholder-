import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/post.dart';
import '../repositories/posts_crud_repository.dart';

class GetPostDetail extends UseCase<Post, Params> {
  final PostsCrudRepository repository;

  GetPostDetail(this.repository);

  @override
  Future<Either<Failure, Post>> call(Params params) async {
    return await repository.getPostDetail(params.id);
  }
}
