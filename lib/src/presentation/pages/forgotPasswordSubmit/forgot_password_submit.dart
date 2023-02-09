import 'package:flutter/cupertino.dart';

import '../../../data/backend/backend.dart';
import '../verification/verification.dart';

class ForgotPasswordSubmitPage extends VerificationPage {
  ForgotPasswordSubmitPage({
    Key? key,
    required String password,
    required super.email,
  }) : super(
          key: key,
          password: password,
          headerText: "Confirm password reset",
          confirm: (code) => Backend.auth.forgotPasswordSubmit(
            email: email,
            newPassword: password,
            code: code,
          ),
          resend: () => Backend.auth.forgotPassword(email),
        );
}
