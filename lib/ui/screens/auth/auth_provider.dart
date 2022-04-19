import 'package:flutter/material.dart';

import '../providers.dart';
import 'auth_model.dart';
import 'auth_view.dart';

/// This screen shows button directing the user to either login screen or signup
/// screen.
class AuthProvider extends PreAuthenticationProvider<AuthModel, AuthView> {
  const AuthProvider({Key? key}) : super(key: key);

  @override
  AuthView buildView(BuildContext context, AuthModel model) => AuthView(
      onClickLogin: () => Navigator.pushNamed(context, '/login'),
      onClickSignup: () => Navigator.pushNamed(context, '/signup'));
}