import 'package:flutter/cupertino.dart';

import '../../../domain/use_cases/use_cases.dart';
import '../verification/ui/verification_page.dart';

class ConfirmEmailPage extends StatelessWidget {
  final String email;
  final void Function(BuildContext context) onConfirmed;

  const ConfirmEmailPage({
    Key? key,
    required this.email,
    required this.onConfirmed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => VerificationPage(
        headerText: "Did you get the\nverification code?",
        email: email,
        confirm: (code) => confirmRegister(email, code).then(
          (either) => either.fold(
            (success) => null,
            (failure) => failure,
          ),
        ),
        resend: () => resendConfirmationCode(email),
        onConfirmed: () => onConfirmed(context),
      );
}
