import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jsonplaceholder_clean_architecture/features/posts_crud/presentation/pages/post_edit_page.dart';
import 'package:jsonplaceholder_clean_architecture/features/posts_crud/presentation/pages/posts_page.dart';
import '../../../../../injection_container.dart';
import '../../bloc/post_bloc.dart';
import '../../../../../core/util/snackbar_message.dart';
import '../../../domain/entities/post.dart';
import '../loading_widget.dart';
import '../message_display.dart';
import 'delete_dialog_widget.dart';

class PostDetailWidget extends StatefulWidget {
  final Post post;
  const PostDetailWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<PostDetailWidget> createState() => _PostDetailWidgetState();
}

class _PostDetailWidgetState extends State<PostDetailWidget> {
  late PostBloc _postBloc;

  @override
  void initState() {
    _postBloc = sl<PostBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.post.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(height: 50),
          Text(
            widget.post.body,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Divider(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _bulidUpdateBtn(),
              _bulidDeleteBtn(),
            ],
          )
        ],
      ),
    );
  }

  _bulidDeleteBtn() {
    return ElevatedButton.icon(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
        onPressed: deleteDialog,
        icon: Icon(Icons.delete_outline),
        label: Text("Delete"));
  }

  void deleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => _postBloc,
          child: StatefulBuilder(
            builder: (context, _setState) {
              return BlocListener<PostBloc, PostState>(
                listener: (context, state) {
                  if (state is MessageState) {
                    SnackBarMessage().showSuccessSnackBar(
                        context: context, message: state.message);

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (ctx) => PostsPage(),
                      ),
                      (_) => false,
                    );
                  }
                },
                child: BlocBuilder<PostBloc, PostState>(
                  builder: (context, state) {
                    if (state is LoadingState || state is MessageState) {
                      return AlertDialog(title: LoadingWidget());
                    } else if (state is ErrorState) {
                      return AlertDialog(
                        title: MessageDisplay(
                          message: state.message,
                        ),
                      );
                    }
                    return DeleteDialog(
                        postBloc: _postBloc, postId: widget.post.id);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  _bulidUpdateBtn() {
    return ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PostEditPage(
                post: widget.post,
              ),
            ),
          );
        },
        icon: Icon(Icons.edit),
        label: Text("Edit"));
  }
}
