import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'features/posts_crud/data/datasources/post_crud_local_data_source.dart';
import 'features/posts_crud/data/datasources/post_crud_remote_data_source.dart';
import 'features/posts_crud/data/repositories/post_crud_repository_impl.dart';
import 'features/posts_crud/domain/repositories/posts_crud_repository.dart';
import 'features/posts_crud/domain/usecases/add_post.dart';
import 'features/posts_crud/domain/usecases/delete_post.dart';
import 'features/posts_crud/domain/usecases/get_all_posts.dart';
import 'features/posts_crud/domain/usecases/get_post_detail.dart';
import 'features/posts_crud/domain/usecases/update_post.dart';
import 'features/posts_crud/presentation/bloc/post_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Post CRUD
  // Bloc
  sl.registerFactory(
    () => PostBloc(
        addPost: sl(),
        deletePost: sl(),
        getAllPosts: sl(),
        getPostDetail: sl(),
        updatePost: sl(),
        networkInfo: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllPosts(sl()));
  sl.registerLazySingleton(() => GetPostDetail(sl()));
  sl.registerLazySingleton(() => AddPost(sl()));
  sl.registerLazySingleton(() => DeletePost(sl()));
  sl.registerLazySingleton(() => UpdatePost(sl()));

  // Repository
  sl.registerLazySingleton<PostsCrudRepository>(
    () => PostsCrudRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<PostCrudRemoteDataSource>(
    () => PostCrudRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<PostCrudLocalDataSource>(
    () => PostCrudLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
