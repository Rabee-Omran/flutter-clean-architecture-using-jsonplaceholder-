import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/post.dart';
import '../../bloc/post_bloc.dart';

class EditFormWidget extends StatefulWidget {
  final Post post;
  const EditFormWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<EditFormWidget> createState() => _EditFormWidgetState();
}

class _EditFormWidgetState extends State<EditFormWidget> {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();

  @override
  void initState() {
    _titleController.text = widget.post.title;
    _bodyController.text = widget.post.body;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTextFormField(
              controller: _titleController, name: "Title", multiLine: false),
          _buildTextFormField(
              controller: _bodyController, name: "Body", multiLine: true),
          SizedBox(
            height: 30,
          ),
          _bulidSubmitBtn()
        ],
      ),
    );
  }

  Widget _buildTextFormField(
      {required TextEditingController controller,
      required String name,
      required bool multiLine}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextFormField(
        controller: controller,
        validator: (val) => val!.isEmpty ? "$name Can't be empty" : null,
        minLines: multiLine ? 6 : 1,
        maxLines: multiLine ? 6 : 1,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: "$name",
        ),
      ),
    );
  }

  void validateAndUpdate() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final post =
          Post(id: 0, title: _titleController.text, body: _bodyController.text);
      BlocProvider.of<PostBloc>(context).add(UpdatePostEvent(post));
    }
  }

  Widget _bulidSubmitBtn() {
    return ElevatedButton.icon(
        onPressed: validateAndUpdate,
        icon: Icon(Icons.edit),
        label: Text("Update"));
  }
}
