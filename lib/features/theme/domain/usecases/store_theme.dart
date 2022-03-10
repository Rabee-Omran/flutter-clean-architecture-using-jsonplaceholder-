import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/theme_repository.dart';

class StoreTheme extends UseCase<bool, int> {
  final ThemeRepository repository;

  StoreTheme(this.repository);

  @override
  Future<Either<Failure, bool>> call(int params) async {
    return await repository.storeTheme(params);
  }
}
