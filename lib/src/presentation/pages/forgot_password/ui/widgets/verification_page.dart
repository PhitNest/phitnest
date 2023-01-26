import 'package:flutter/cupertino.dart';

import '../../../../../domain/use_cases/forgot_password_submit.dart';
import '../../../../../domain/use_cases/use_cases.dart';
import '../../../pages.dart';
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
  Widget build(BuildContext context) {
    return VerificationPage(
      headerText:
          "Check $email for a verification\ncode from us and enter it below",
      confirm: (code) => forgotPasswordSubmit(
        email,
        password,
        code,
      ).then(
        (res) => res == null ? null : res,
      ),
      resend: () => resendConfirmationCode(email),
      onConfirmed: () => Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => LoginPage(),
        ),
      ),
    );
  }
}
