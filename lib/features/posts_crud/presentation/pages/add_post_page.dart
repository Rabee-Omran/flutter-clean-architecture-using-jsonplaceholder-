import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/snackbar_message.dart';
import '../../../../injection_container.dart';
import '../bloc/post_bloc.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display.dart';
import '../widgets/post_add_page/add_form_widget.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
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
          title: Text("Add Post"),
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
              Navigator.of(context).pop();
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
              return AddFormWidget();
            },
          ),
        ),
      ),
    );
  }
}
