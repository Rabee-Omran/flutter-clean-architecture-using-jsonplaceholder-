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
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PostBloc>(context).add(GetAllPostsEvent());
    _scrollController.addListener(_onScroll);
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
            if (state is InitialState) {
              return LoadingWidget();
            } else if (state is LoadingState) {
              return LoadingWidget();
            } else if (state is LoadedPostsState) {
              posts = state.posts;
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: PostList(
                  scrollController: _scrollController,
                  state: state,
                ),
              );
            } else if (state is ErrorState) {
              return MessageDisplay(
                message: state.message,
              );
            } else if (state is LoadedPostDetailState) {
              print(state);
              return Text('dfdf');
            }
            return SizedBox();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    BlocProvider.of<PostBloc>(context)..add(PostsRefreshEvent());
  }

  void _onScroll() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;
    if (currentScroll == maxScroll)
      BlocProvider.of<PostBloc>(context)..add(GetAllPostsEvent());
  }
}
