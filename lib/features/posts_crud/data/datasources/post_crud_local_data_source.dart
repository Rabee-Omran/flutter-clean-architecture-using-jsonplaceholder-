import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exception.dart';
import '../models/post_model.dart';

abstract class PostCrudLocalDataSource {
  Future<List<PostModel>> getLast20Posts();

  Future<void> cacheLast20Posts(List<PostModel> postsToCache);
}

const CACHED_POSTS = 'CACHED_POSTS';

class PostCrudLocalDataSourceImpl implements PostCrudLocalDataSource {
  final SharedPreferences sharedPreferences;

  PostCrudLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheLast20Posts(List<PostModel> postsToCache) {
    List postsModelToJson = [];
    for (int i = 0; i < postsToCache.length; i++) {
      postsModelToJson.add(postsToCache[i].toJson());
    }
    return sharedPreferences.setString(
      CACHED_POSTS,
      json.encode(postsModelToJson),
    );
  }

  @override
  Future<List<PostModel>> getLast20Posts() {
    final jsonString = sharedPreferences.getString(CACHED_POSTS);

    if (jsonString != null) {
      List decodeJsonData = json.decode(jsonString);
      List<PostModel> jsonToPostsModel = [];

      for (int i = 0; i < decodeJsonData.length; i++) {
        jsonToPostsModel.add(PostModel.fromJson(decodeJsonData[i]));
      }

      return Future.value(jsonToPostsModel);
    } else {
      throw CacheException();
    }
  }
}
