import 'package:dartz/dartz.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

typedef Future<User> _LoginOrRegister();

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final currentUser = await localDataSource.getCurrentUser();
      return Right(currentUser);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, User>> loginUser({required Map authData}) async {
    return await _loginOrRegister(() {
      return remoteDataSource.loginUser(authData: authData);
    });
  }

  @override
  Future<Either<Failure, User>> registerUser({required Map authData}) async {
    return await _loginOrRegister(() {
      return remoteDataSource.registerUser(authData: authData);
    });
  }

  Future<Either<Failure, User>> _loginOrRegister(
    _LoginOrRegister loginOrRegister,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await loginOrRegister();

        final userModel = UserModel(
            id: user.id,
            username: user.username,
            email: user.email,
            image: user.image,
            token: user.token);

        localDataSource.saveUser(userModel);
        return Right(user);
      } on ServerException {
        return Left(ServerFailure());
      } on InvalidDataException {
        return Left(InvalidDataFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final isDone = await localDataSource.logOut();
      return Right(isDone);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
