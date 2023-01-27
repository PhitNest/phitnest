import 'package:flutter/cupertino.dart';

import '../../../../../domain/use_cases/forgot_password_submit.dart';
import '../../../../../domain/use_cases/use_cases.dart';
import '../../../verification/ui/verification_page.dart';

class VerifyEmail extends StatelessWidget {
  final String email;
  final String password;

  const VerifyEmail({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => VerificationPage(
        headerText: "Confirm password reset",
        email: email,
        confirm: (code) => forgotPasswordSubmit(
          email,
          password,
          code,
        ),
        resend: () => forgotPassword(email),
        onConfirmed: () => Navigator.of(context).popUntil(
          (route) => route.isFirst,
        ),
      );
}
