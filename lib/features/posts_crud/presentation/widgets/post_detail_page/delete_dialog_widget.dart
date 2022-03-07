import 'package:flutter/material.dart';

import '../../bloc/post_bloc.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({
    Key? key,
    required PostBloc postBloc,
    required this.postId,
  })  : _postBloc = postBloc,
        super(key: key);

  final PostBloc _postBloc;
  final int postId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Are you Sure ?"),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("No"),
        ),
        TextButton(
          onPressed: () async {
            _postBloc.add(DeletePostEvent(postId));
          },
          child: Text("Yes"),
        ),
      ],
    );
  }
}
