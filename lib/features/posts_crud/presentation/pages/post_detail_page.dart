import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../widgets/post_detail_page/post_detail_widget.dart';
import '../../domain/entities/post.dart';
import '../bloc/post_bloc.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Post Detail"),
        ),
        body: buildBody(context));
  }

  Widget buildBody(BuildContext context) {
    return BlocProvider<PostBloc>(
      create: (_) => sl<PostBloc>()..add(GetPostDetailEvent(widget.post.id)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return LoadingWidget();
              } else if (state is LoadedPostDetailState) {
                return PostDetailWidget(
                  post: state.post,
                );
              } else if (state is ErrorState) {
                return MessageDisplay(
                  message: state.message,
                );
              }
              return LoadingWidget();
            },
          ),
        ),
      ),
    );
  }
}
