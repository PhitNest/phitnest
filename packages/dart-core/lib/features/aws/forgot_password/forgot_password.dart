import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:equatable/equatable.dart';

import '../../logger.dart';
import '../aws.dart';

part 'params.dart';
part 'response.dart';

Future<SendForgotPasswordResponse> sendForgotPasswordRequest(
  String email,
) async {
  try {
    final user = CognitoUser(email, userPool);
    await user.forgotPassword();
    return SendForgotPasswordSuccess(user);
  } on CognitoClientException catch (e) {
    error(e.toString());
    return switch (e.code) {
      'ResourceNotFoundException' => const SendForgotPasswordKnownFailure(
          SendForgotPasswordFailure.invalidUserPool),
      'InvalidParameterException' => const SendForgotPasswordKnownFailure(
          SendForgotPasswordFailure.invalidEmail),
      'UserNotFoundException' => const SendForgotPasswordKnownFailure(
          SendForgotPasswordFailure.noSuchUser),
      _ => SendForgotPasswordUnknownFailure(message: e.message),
    };
  } on ArgumentError catch (e) {
    error(e.toString());
    return const SendForgotPasswordKnownFailure(
      SendForgotPasswordFailure.invalidUserPool,
    );
  } catch (e) {
    error(e.toString());
    return SendForgotPasswordUnknownFailure(message: e.toString());
  }
}

Future<SubmitForgotPasswordFailure?> submitForgotPassword({
  required SubmitForgotPasswordParams params,
  required UnauthenticatedSession session,
}) async {
  try {
    if (await session.user.confirmPassword(params.code, params.newPassword)) {
      return null;
    } else {
      return SubmitForgotPasswordFailure.invalidCode;
    }
  } on CognitoClientException catch (e) {
    error(e.toString());
    return switch (e.code) {
      'ResourceNotFoundException' =>
        SubmitForgotPasswordFailure.invalidUserPool,
      'InvalidParameterException' =>
        SubmitForgotPasswordFailure.invalidCodeOrPassword,
      'CodeMismatchException' => SubmitForgotPasswordFailure.invalidCode,
      'ExpiredCodeException' => SubmitForgotPasswordFailure.expiredCode,
      'UserNotFoundException' => SubmitForgotPasswordFailure.noSuchUser,
      _ => SubmitForgotPasswordFailure.unknown,
    };
  } catch (e) {
    error(e.toString());
    return SubmitForgotPasswordFailure.unknown;
  }
}
