part of 'aws.dart';

Future<bool> confirmEmail({
  required CognitoUser user,
  required String code,
}) async {
  try {
    await user.confirmRegistration(code);
    return true;
  } catch (_) {
    return false;
  }
}

Future<bool> resendConfirmationEmail({
  required CognitoUser user,
}) async {
  try {
    await user.resendConfirmationCode();
    return true;
  } catch (_) {
    return false;
  }
}
