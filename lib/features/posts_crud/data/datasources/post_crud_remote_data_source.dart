import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';
import '../../../../core/error/exception.dart';
import '../../domain/entities/post.dart';

const BASE_URL = 'https://jsonplaceholder.typicode.com';

abstract class PostCrudRemoteDataSource {
  Future<List<Post>> getAllPosts({required int start, required int limit});
  Future<Post> getPostDetail(int id);
  Future<bool> deletePost(int id);
  Future<bool> updatePost(Post post);
  Future<bool> addPost(Post post);
}

class PostCrudRemoteDataSourceImpl implements PostCrudRemoteDataSource {
  final http.Client client;

  PostCrudRemoteDataSourceImpl({required this.client});

  @override
  Future<List<Post>> getAllPosts(
      {required int start, required int limit}) async {
    final response = await client.get(
      Uri.parse(BASE_URL + "/posts/?_start=$start&_limit=$limit"),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List decodedJson = json.decode(response.body) as List;
      final List<Post> postsData = [];
      for (var i = 0; i < decodedJson.length; i++) {
        postsData.add(PostModel.fromJson(decodedJson[i]));
      }
      return postsData;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Post> getPostDetail(int id) async {
    final response = await client.get(
      Uri.parse(BASE_URL + "/posts/${id.toString()}"),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return PostModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> addPost(Post post) async {
    final body = {
      "title": post.title,
      "body": post.body,
    };
    final response =
        await client.post(Uri.parse(BASE_URL + "/posts/"), body: body);

    if (response.statusCode == 201) {
      return true;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> deletePost(int id) async {
    final response = await client.delete(
      Uri.parse(BASE_URL + "/posts/${id.toString()}"),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> updatePost(Post post) async {
    final postId = post.id.toString();
    final body = {
      "title": post.title,
      "body": post.body,
    };
    final response =
        await client.patch(Uri.parse(BASE_URL + "/posts/$postId"), body: body);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw ServerException();
    }
  }
}
