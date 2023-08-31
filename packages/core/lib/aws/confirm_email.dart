part of 'aws.dart';

Future<bool> confirmEmail({
  required CognitoUser user,
  required String code,
}) async {
  try {
    return await user.confirmRegistration(code);
  } catch (e) {
    error(e.toString());
    return false;
  }
}

Future<bool> resendConfirmationEmail({
  required CognitoUser user,
}) async {
  try {
    await user.resendConfirmationCode();
    return true;
  } catch (e) {
    error(e.toString());
    return false;
  }
}
