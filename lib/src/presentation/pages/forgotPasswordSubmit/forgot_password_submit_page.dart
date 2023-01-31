import 'package:flutter/cupertino.dart';

import '../../../domain/use_cases/use_cases.dart';
import '../pages.dart';

class ForgotPasswordSubmitPage extends VerificationPage {
  ForgotPasswordSubmitPage({
    Key? key,
    required String password,
    required super.email,
  }) : super(
          key: key,
          password: password,
          headerText: "Confirm password reset",
          confirm: (code) => forgotPasswordSubmit(
            email,
            password,
            code,
          ),
          resend: () => forgotPassword(email),
        );
}
