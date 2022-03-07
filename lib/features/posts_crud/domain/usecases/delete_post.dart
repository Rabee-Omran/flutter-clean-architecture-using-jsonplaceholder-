import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/posts_crud_repository.dart';

class DeletePost extends UseCase<bool, Params> {
  final PostsCrudRepository repository;

  DeletePost(this.repository);

  @override
  Future<Either<Failure, bool>> call(Params params) async {
    return await repository.deletePost(params.id);
  }
}
