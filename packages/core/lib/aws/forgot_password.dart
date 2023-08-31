part of 'aws.dart';

sealed class SendForgotPasswordResponse extends Equatable {
  const SendForgotPasswordResponse() : super();
}

final class SendForgotPasswordSuccess extends SendForgotPasswordResponse {
  final CognitoUser user;

  const SendForgotPasswordSuccess(this.user) : super();

  @override
  List<Object?> get props => [user];
}

enum SendForgotPasswordFailure {
  invalidUserPool,
  invalidEmail,
  noSuchUser;

  String get message => switch (this) {
        SendForgotPasswordFailure.invalidUserPool => kInvalidPool,
        SendForgotPasswordFailure.invalidEmail => kInvalidEmail,
        SendForgotPasswordFailure.noSuchUser => kNoSuchUser,
      };
}

sealed class SendForgotPasswordFailureResponse
    extends SendForgotPasswordResponse {
  String get message;

  const SendForgotPasswordFailureResponse() : super();
}

final class SendForgotPasswordKnownFailure
    extends SendForgotPasswordFailureResponse {
  @override
  String get message => type.message;

  final SendForgotPasswordFailure type;

  const SendForgotPasswordKnownFailure(this.type) : super();

  @override
  List<Object?> get props => [type];
}

final class SendForgotPasswordUnknownFailure
    extends SendForgotPasswordFailureResponse {
  @override
  final String message;

  const SendForgotPasswordUnknownFailure({
    required String? message,
  })  : message = message ?? kUnknownError,
        super();

  @override
  List<Object?> get props => [message];
}

Future<SendForgotPasswordResponse> sendForgotPasswordRequest({
  required String email,
  required ApiInfo apiInfo,
}) async {
  try {
    final user = CognitoUser(email, apiInfo.pool);
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

enum SubmitForgotPasswordFailure {
  invalidUserPool,
  invalidEmail,
  invalidPassword,
  noSuchUser,
  invalidCodeOrPassword,
  invalidCode,
  expiredCode,
  unknown;

  String get message => switch (this) {
        SubmitForgotPasswordFailure.invalidUserPool => kInvalidPool,
        SubmitForgotPasswordFailure.invalidEmail => kInvalidEmail,
        SubmitForgotPasswordFailure.invalidPassword => kInvalidPassword,
        SubmitForgotPasswordFailure.noSuchUser => kNoSuchUser,
        SubmitForgotPasswordFailure.unknown => kUnknownError,
        SubmitForgotPasswordFailure.invalidCodeOrPassword =>
          'Invalid code or password.',
        SubmitForgotPasswordFailure.invalidCode => 'Invalid code.',
        SubmitForgotPasswordFailure.expiredCode => 'Expired code.',
      };
}

final class SubmitForgotPasswordParams extends Equatable {
  final String email;
  final String code;
  final String newPassword;

  const SubmitForgotPasswordParams({
    required this.email,
    required this.code,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, code, newPassword];
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
