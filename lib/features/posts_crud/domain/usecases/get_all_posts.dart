import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/post.dart';
import '../repositories/posts_crud_repository.dart';

class GetAllPosts extends UseCase<List<Post>, NoParams> {
  final PostsCrudRepository repository;

  GetAllPosts(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(NoParams params) async {
    return await repository.getAllPosts();
  }
}
