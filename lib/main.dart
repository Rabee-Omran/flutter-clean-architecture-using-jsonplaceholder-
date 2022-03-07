import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/posts_crud/presentation/bloc/post_bloc.dart';
import 'features/posts_crud/presentation/pages/posts_page.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PostBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Post CRUD',
        theme: ThemeData(
          appBarTheme: AppBarTheme(backgroundColor: Colors.blue.shade800),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.blue.shade800,
          ),
          buttonTheme: ButtonThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        home: PostsPage(),
      ),
    );
  }
}
