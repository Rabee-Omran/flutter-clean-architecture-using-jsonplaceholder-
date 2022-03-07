import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/post.dart';
import '../repositories/posts_crud_repository.dart';

class AddPost extends UseCase<bool, Post> {
  final PostsCrudRepository repository;

  AddPost(this.repository);

  @override
  Future<Either<Failure, bool>> call(Post params) async {
    return await repository.addPost(params);
  }
}
