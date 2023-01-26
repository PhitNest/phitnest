import 'package:flutter/cupertino.dart';

import '../../../../../domain/use_cases/use_cases.dart';
import '../../../pages.dart';
import '../../../verification/ui/verification_page.dart';

class VerifyEmail extends StatelessWidget {
  final String email;

  const VerifyEmail({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VerificationPage(
      headerText:
          "Check $email for a verification\ncode from us and enter it below",
      confirm: (code) => confirmRegister(email, code).then(
        (either) => either.fold(
          (success) => null,
          (failure) => failure,
        ),
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
