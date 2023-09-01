import 'package:amazon_cognito_identity_dart_2/cognito.dart';

import '../logger.dart';

Future<String?> confirmEmail({
  required CognitoUser user,
  required String code,
}) async {
  try {
    if (await user.confirmRegistration(code)) {
      return null;
    } else {
      return 'Failed to confirm email';
    }
  } catch (e) {
    error(e.toString());
    return e.toString();
  }
}

Future<String?> resendConfirmationEmail({
  required CognitoUser user,
}) async {
  try {
    await user.resendConfirmationCode();
    return null;
  } catch (e) {
    error(e.toString());
    return e.toString();
  }
}
