import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final Icon icon;
  final bool isPassword;
  final bool isEmail;

  const TextFieldWidget(
      {Key? key,
      required this.title,
      required this.controller,
      required this.icon,
      required this.isEmail,
      required this.isPassword})
      : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.isEmail
                ? TextInputType.emailAddress
                : TextInputType.text,
            obscureText: widget.isPassword,
            validator: (val) =>
                val!.isEmpty ? "Please Enter Your ${widget.title}" : null,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).primaryColor)),
              border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).primaryColor)),
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: widget.icon,
              hintText: 'Enter your ${widget.title}',
            ),
          ),
        ),
      ],
    );
  }
}
