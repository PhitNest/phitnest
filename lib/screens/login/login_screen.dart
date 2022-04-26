import 'package:flutter/material.dart';

import 'provider/login_provider.dart';
import 'ui/login_view.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginScreenProvider(
      builder: ((context, model, functions, child) {
        return LoginView(
          formKey: model.formKey,
          validate: model.validate,
          updateEmail: functions.updateEmail,
          updatePassword: functions.updatePassword,
          clickLogin: functions.login,
          clickResetPassword: functions.resetPassword,
          clickPhone: functions.loginWithPhone,
          clickFacebook: functions.loginWithFacebook,
          showApple: functions.showApple(),
          clickApple: functions.loginWithApple,
        );
      }),
    );
  }
}
