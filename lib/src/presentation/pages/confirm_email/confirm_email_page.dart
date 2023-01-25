import 'package:flutter/cupertino.dart';

import '../../../data/data_sources/backend/backend.dart';
import '../pages.dart';
import '../verification/ui/verification.dart';

class ConfirmEmailPage extends StatelessWidget {
  final String email;

  const ConfirmEmailPage({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => VerificationPage(
        headerText:
            "Check $email for a verification\ncode from us and enter it below",
        confirm: (code) => authBackend.confirmRegister(email, code).then(
              (either) => either.fold(
                (success) => null,
                (failure) => failure,
              ),
            ),
        resend: () => authBackend.resendConfirmationCode(email),
        onConfirmed: () => Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => HomePage(),
          ),
          (_) => false,
        ),
      );
}
