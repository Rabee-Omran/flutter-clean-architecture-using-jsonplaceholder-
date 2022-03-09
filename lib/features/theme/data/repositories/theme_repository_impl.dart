import 'package:dartz/dartz.dart';
import '../../domain/repositories/theme_repository.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failures.dart';
import '../datasources/theme_local_data_source.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource localDataSource;

  ThemeRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, int>> getStoredTheme() async {
    try {
      final theme = await localDataSource.getStoredTheme();
      return Right(theme);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> storeTheme(int themeIndex) async {
    try {
      await localDataSource.storedTheme(themeIndex);
      return Right(true);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
