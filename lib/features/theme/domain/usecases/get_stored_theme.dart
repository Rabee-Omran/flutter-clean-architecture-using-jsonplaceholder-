import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/theme_repository.dart';

class GetStoredTheme extends UseCase<int, NoParams> {
  final ThemeRepository repository;

  GetStoredTheme(this.repository);

  @override
  Future<Either<Failure, int>> call(NoParams params) async {
    return await repository.getStoredTheme();
  }
}
