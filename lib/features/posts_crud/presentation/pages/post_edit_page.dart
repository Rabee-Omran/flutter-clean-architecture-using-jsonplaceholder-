import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/snackbar_message.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/post.dart';
import '../bloc/post_bloc.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display.dart';
import '../widgets/post_edit_page/edit_form_widget.dart';

class PostEditPage extends StatefulWidget {
  final Post post;
  const PostEditPage({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<PostEditPage> createState() => _PostEditPageState();
}

class _PostEditPageState extends State<PostEditPage> {
  late PostBloc _postBloc;

  @override
  void initState() {
    _postBloc = sl<PostBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Post"),
        ),
        body: BlocProvider<PostBloc>(
          create: (context) => _postBloc,
          child: buildBody(context),
        ));
  }

  Widget buildBody(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: BlocListener<PostBloc, PostState>(
          listener: (context, state) {
            if (state is MessageState) {
              SnackBarMessage().showSuccessSnackBar(
                  context: context, message: state.message);
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (ctx) => PostEditPage(post: widget.post)));
            }
          },
          child: BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return LoadingWidget();
              } else if (state is ErrorState) {
                return MessageDisplay(
                  message: state.message,
                );
              }
              return EditFormWidget(post: widget.post);
            },
          ),
        ),
      ),
    );
  }
}
