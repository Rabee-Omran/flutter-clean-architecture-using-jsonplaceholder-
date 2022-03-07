import 'package:flutter/material.dart';
import 'add_post_page.dart';
import '../../domain/entities/post.dart';
import '../bloc/post_bloc.dart';
import '../widgets/loading_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/message_display.dart';
import '../widgets/posts_page/post_list.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PostBloc>(context).add(GetAllPostsEvent());
  }

  List<Post> posts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddPostPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return LoadingWidget();
            } else if (state is LoadedPostsState) {
              posts = state.posts;
              return PostList(
                posts: state.posts,
              );
            } else if (state is ErrorState) {
              return MessageDisplay(
                message: state.message,
              );
            } else {
              return PostList(
                posts: posts,
              );
            }
          },
        ),
      ),
    );
  }
}
