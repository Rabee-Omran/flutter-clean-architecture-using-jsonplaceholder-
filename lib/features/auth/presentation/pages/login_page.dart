import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/snackbar_message.dart';
import '../../../posts_crud/presentation/pages/posts_page.dart';
import '../../../posts_crud/presentation/widgets/loading_widget.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/login_page/login_form_widget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                left: 40.0,
                right: 40.0,
                top: 90.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/icons/app-icon.png',
                    height: 150,
                  ),
                  SizedBox(height: 30.0),
                  BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is MessageState) {
                        SnackBarMessage().showErrorSnackBar(
                            context: context, message: state.message);
                      } else if (state is AuthErrorState) {
                        SnackBarMessage().showErrorSnackBar(
                            context: context, message: state.message);
                      } else if (state is LoadedUserState) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (ctx) => PostsPage()),
                            (_) => false);
                      }
                    },
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoadingState) {
                          return LoadingWidget();
                        }
                        return LoginFormWidget();
                      },
                    ),
                  ),
                ],
              ),
            ),
            _exitToHome(context),
          ],
        ),
      ),
    );
  }

  Positioned _exitToHome(BuildContext context) {
    return Positioned(
        top: 10,
        right: 10,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (ctx) => PostsPage()), (_) => false);
          },
          child: CircleAvatar(
            radius: 15,
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ));
  }
}
