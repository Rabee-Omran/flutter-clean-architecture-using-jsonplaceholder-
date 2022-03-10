import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../pages/register_page.dart';

import '../../bloc/auth_bloc.dart';
import '../build_text_field.dart';

class LoginFormWidget extends StatefulWidget {
  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = new GlobalKey<FormState>();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFieldWidget(
              title: 'Username',
              isEmail: false,
              controller: _usernameController,
              icon: Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
              ),
              isPassword: false),
          SizedBox(
            height: 15.0,
          ),
          TextFieldWidget(
              title: 'Password',
              isEmail: false,
              controller: _passwordController,
              icon: Icon(Icons.lock, color: Theme.of(context).primaryColor),
              isPassword: true),
          _buildLoginBtn(),
          _buildSignupBtn(),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      width: double.infinity,
      child: ElevatedButton(
        child: Text("Sign-In", style: TextStyle(fontSize: 14)),
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
            backgroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).primaryColor,
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: Theme.of(context).primaryColor,
                    )))),
        onPressed: () {
          final isValid = _formKey.currentState!.validate();

          if (isValid) {
            Map authData = {
              "username": _usernameController.text,
              "password": _passwordController.text,
            };
            BlocProvider.of<AuthBloc>(context)..add(LoginUserEvent(authData));
          }
        },
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => RegisterPage()),
        );
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                fontSize: 14.0,
                color: Theme.of(context).textTheme.bodyText1!.color,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
