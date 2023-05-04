import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/get_it.dart';
import '../home/home_widget.dart';
import 'auth_model.dart';
import '../channels/channels_screen.dart';
import '../login/login_screen.dart';
import '../signup/signup_screen.dart';
import 'auth_view_model.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: getIt<AuthViewModel>(),
      builder: (_, ch) {
        return Selector<AuthViewModel, AuthModel>(
          selector: (_, p) => p.auth,
          builder: (_, auth, ch) {
            switch (auth.state) {
              case AuthState.signup:
                return SignUpScreen();
              case AuthState.login:
                return LoginWidget();
              case AuthState.authenticated:
                return  const ChannelsScreen();
            }
          },
        );
      },
    );
  }
}
