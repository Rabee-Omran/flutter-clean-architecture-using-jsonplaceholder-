import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required int id,
    required String username,
    required String email,
    required String image,
    required String token,
  }) : super(
          id: id,
          username: username,
          email: email,
          image: image,
          token: token,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      image: json['image'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'image': image,
      'token': token,
    };
  }
}
