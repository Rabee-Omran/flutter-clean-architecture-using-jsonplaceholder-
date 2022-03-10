import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/pages/login_page.dart';

import '../../../../core/app_themes.dart';
import '../../../../core/util/snackbar_message.dart';
import '../bloc/theme_bloc.dart';

class PreferencePage extends StatefulWidget {
  @override
  State<PreferencePage> createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {
  @override
  void initState() {
    BlocProvider.of<AuthBloc>(context).add(GetCurrentUserEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is MessageState) {
          SnackBarMessage()
              .showSuccessSnackBar(context: context, message: state.message);
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Preferences'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  state is LoadedUserState
                      ? _profileData(
                          username: state.user.username,
                          email: state.user.email)
                      : SizedBox(),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: AppTheme.values.length,
                    itemBuilder: (context, index) {
                      final itemAppTheme = AppTheme.values[index];
                      return Card(
                        color: appThemeData[itemAppTheme]!.primaryColor,
                        child: ListTile(
                          title: Text(
                            itemAppTheme.name.toString(),
                            style:
                                appThemeData[itemAppTheme]!.textTheme.bodyText2,
                          ),
                          onTap: () {
                            BlocProvider.of<ThemeBloc>(context).add(
                              ThemeChangedEvent(theme: itemAppTheme),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  state is LoadedUserState ? _logoutBtn() : _logInBtn()
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Column _profileData({required String username, required String email}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Profile",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 12,
        ),
        _dataRow(data: username, icon: Icons.person),
        SizedBox(
          height: 5,
        ),
        _dataRow(data: email, icon: Icons.email),
        SizedBox(
          height: 8,
        ),
        Divider(),
        Text(
          "Themes",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget _logoutBtn() {
    return Column(
      children: [
        Divider(),
        SizedBox(
          height: 8,
        ),
        InkWell(
          onTap: () {
            BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
          },
          child: Row(
            children: [
              Icon(
                Icons.logout,
                size: 20,
                color: Colors.redAccent,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Logout",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _logInBtn() {
    return Column(
      children: [
        Divider(),
        SizedBox(
          height: 8,
        ),
        InkWell(
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => LoginPage())),
          child: Row(
            children: [
              Icon(
                Icons.login,
                size: 20,
                color: Colors.redAccent,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Login",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row _dataRow({required IconData icon, required String data}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 17,
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          data,
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}
