import 'package:flutter/material.dart';
import 'package:progress_widgets/progress_widgets.dart';
import 'package:validation/validation.dart';

import '../providers.dart';
import 'login_model.dart';
import 'login_view.dart';

class LoginProvider extends PreAuthenticationProvider<LoginModel, LoginView> {
  const LoginProvider({Key? key}) : super(key: key);

  @override
  LoginView buildView(BuildContext context, LoginModel model) => LoginView(
        formKey: model.formKey,
        validate: model.validate,
        validateEmail: validateEmail,
        onSaveEmail: (String? email) => model.email = email,
        validatePassword: validatePassword,
        onSavePassword: (String? password) => model.password = password,
        onClickLogin: (String method) => showProgressUntil(
            context: context,
            message: 'Logging in, please wait...',
            showUntil: () => model.login(method),
            onDone: (result) {
              if (result != null) {
                showAlertDialog(context, 'Login Failed', result);
              } else {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (_) => false);
              }
            }),
        onClickResetPassword: () =>
            Navigator.pushNamed(context, '/resetPassword'),
        onClickMobile: () => Navigator.pushNamed(context, '/mobileAuth'),
      );
}
