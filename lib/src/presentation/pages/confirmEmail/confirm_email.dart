import 'package:flutter/cupertino.dart';

import '../../../data/backend/backend.dart';
import '../../../domain/repositories/repository.dart';
import '../verification/verification.dart';

class ConfirmEmailPage extends StatelessWidget {
  final String email;
  final String? password;
  final bool shouldLogin;

  /// **POP RESULT: [LoginResponse] if [shouldLogin] and the login request succeeds, null otherwise**
  ///
  /// if [shouldLogin] is true, then [password] must not be null.
  const ConfirmEmailPage({
    Key? key,
    required this.email,
    required this.password,
    this.shouldLogin = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => VerificationPage(
        headerText: "Did you get the\nverification code?",
        email: email,
        confirm: (code) => Repositories.auth
            .confirmRegister(
              email: email,
              code: code,
            )
            .then(
              (either) => either.fold(
                (_) => null,
                (failure) => failure,
              ),
            ),
        resend: () => Backend.auth.resendConfirmation(email),
        password: password,
        shouldLogin: shouldLogin,
      );
}
