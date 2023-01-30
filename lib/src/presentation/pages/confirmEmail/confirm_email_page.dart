import 'package:flutter/cupertino.dart';

import '../../../data/data_sources/backend/backend.dart';
import '../../../domain/use_cases/use_cases.dart';
import '../verification/ui/verification_page.dart';

class ConfirmEmailPage extends StatelessWidget {
  final String email;
  final bool shouldLogin;
  final String? password;

  final void Function(BuildContext context, LoginResponse? response)
      onConfirmed;

  const ConfirmEmailPage({
    Key? key,
    required this.email,
    required this.onConfirmed,
    required this.password,
    this.shouldLogin = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => VerificationPage(
        headerText: "Did you get the\nverification code?",
        email: email,
        confirm: (code) => confirmRegister(email, code),
        resend: () => resendConfirmation(email),
        password: password,
        shouldLogin: shouldLogin,
        onConfirmed: (response) => onConfirmed(context, response),
      );
}
