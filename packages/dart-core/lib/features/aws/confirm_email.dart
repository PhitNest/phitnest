import 'package:amazon_cognito_identity_dart_2/cognito.dart';

import '../logger.dart';

/// Verifies a users email address using a 6-digit pin code sent by AWS Cognito
///
/// Returns null if successful, otherwise an error message
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
  } on CognitoClientException catch (e) {
    final errorMessage = e.message ?? e.toString();
    error(errorMessage);
    return errorMessage;
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
