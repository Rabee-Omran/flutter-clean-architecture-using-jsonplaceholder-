import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/posts_crud/presentation/bloc/post_bloc.dart';
import 'features/posts_crud/presentation/pages/posts_page.dart';
import 'features/posts_crud/presentation/widgets/loading_widget.dart';
import 'features/theme/presentation/bloc/theme_bloc.dart';
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
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (_) => sl<PostBloc>(),
      ),
      BlocProvider(create: (_) => sl<ThemeBloc>()..add(InitialThemeEvent())),
    ], child: _buildWithTheme());
  }

  Widget _buildWithTheme() {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        if (state is ThemeLoadingState) {
          return LoadingWidget();
        } else if (state is ThemeLoadedState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Post CRUD',
            theme: state.themeData,
            home: PostsPage(),
          );
        }
        return LoadingWidget();
      },
    );
  }
}
