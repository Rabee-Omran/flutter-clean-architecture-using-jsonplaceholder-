import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class ThemeRepository {
  Future<Either<Failure, int>> getStoredTheme();
  Future<Either<Failure, bool>> storeTheme(int themeIndex);
}
