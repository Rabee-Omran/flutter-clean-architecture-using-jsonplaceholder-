import 'package:flutter/material.dart';
import '../loading_widget.dart';
import '../../bloc/post_bloc.dart';
import '../../pages/post_detail_page.dart';

class PostList extends StatelessWidget {
  final LoadedPostsState state;
  final ScrollController scrollController;
  const PostList({
    Key? key,
    required this.scrollController,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount:
          state.hasReachedMax ? state.posts.length : state.posts.length + 1,
      controller: scrollController,
      itemBuilder: (context, index) {
        if (index >= state.posts.length) return LoadingWidget();
        return ListTile(
          leading: Text(state.posts[index].id.toString()),
          title: Text(
            state.posts[index].title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            state.posts[index].body,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 10),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PostDetailPage(post: state.posts[index]),
              ),
            );
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(
        thickness: 1,
      ),
    );
  }
}
