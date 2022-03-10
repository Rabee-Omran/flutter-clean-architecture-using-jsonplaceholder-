import 'package:http/http.dart' as http;

import '../../../../core/error/exception.dart';
import '../../domain/entities/user.dart';

const BASE_URL = 'FAKE URL JUST FOR TESTING :(';

abstract class AuthRemoteDataSource {
  Future<User> loginUser({required Map authData});
  Future<User> registerUser({required Map authData});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<User> loginUser({required Map authData}) async {
    await Future.delayed(Duration(seconds: 2));

    if (authData['username'] == 'rabee' && authData['password'] == "1234") {
      final User user = User(
          id: 1,
          username: "Rabee",
          email: "Rabee@gmail.com",
          image: "",
          token: "");
      return Future.value(user);
    } else {
      throw InvalidDataException();
    }
  }

  @override
  Future<User> registerUser({required Map authData}) async {
    await Future.delayed(Duration(seconds: 2));
    final User user = User(
        id: 1,
        username: "Rabee",
        email: "Rabee@gmail.com",
        image: "",
        token: "");
    return Future.value(user);
  }
}
