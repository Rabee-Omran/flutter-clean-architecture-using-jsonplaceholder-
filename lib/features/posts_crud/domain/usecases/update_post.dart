import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/post.dart';
import '../repositories/posts_crud_repository.dart';

class UpdatePost extends UseCase<bool, Post> {
  final PostsCrudRepository repository;

  UpdatePost(this.repository);

  @override
  Future<Either<Failure, bool>> call(Post params) async {
    return await repository.updatePost(params);
  }
}
