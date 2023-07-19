part of 'cognito.dart';

sealed class SendForgotPasswordResponse extends Equatable {
  const SendForgotPasswordResponse() : super();
}

final class SendForgotPasswordSuccess extends SendForgotPasswordResponse {
  final CognitoUser user;

  const SendForgotPasswordSuccess(this.user) : super();

  @override
  List<Object?> get props => [user];
}

enum ForgotPasswordFailure {
  invalidUserPool,
  invalidEmail,
  noSuchUser,
  unknown;

  String get message => switch (this) {
        ForgotPasswordFailure.invalidUserPool => kInvalidPool,
        ForgotPasswordFailure.invalidEmail => kInvalidEmail,
        ForgotPasswordFailure.noSuchUser => kNoSuchUser,
        ForgotPasswordFailure.unknown => kUnknownError,
      };
}

sealed class SendForgotPasswordFailureResponse
    extends SendForgotPasswordResponse {
  String get message;

  const SendForgotPasswordFailureResponse() : super();
}

final class SendForgotPasswordFailure
    extends SendForgotPasswordFailureResponse {
  @override
  String get message => type.message;

  final ForgotPasswordFailure type;

  const SendForgotPasswordFailure(this.type) : super();

  @override
  List<Object?> get props => [type];
}

final class SendForgotPasswordUnknownResponse
    extends SendForgotPasswordFailureResponse {
  @override
  final String message;

  const SendForgotPasswordUnknownResponse({
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
  } on CognitoClientException catch (error) {
    return switch (error.code) {
      'ResourceNotFoundException' =>
        SendForgotPasswordFailure(ForgotPasswordFailure.invalidUserPool),
      'InvalidParameterException' =>
        SendForgotPasswordFailure(ForgotPasswordFailure.invalidEmail),
      'UserNotFoundException' =>
        SendForgotPasswordFailure(ForgotPasswordFailure.noSuchUser),
      _ => SendForgotPasswordUnknownResponse(message: error.message),
    };
  } on ArgumentError catch (_) {
    return SendForgotPasswordFailure(ForgotPasswordFailure.invalidUserPool);
  } catch (error) {
    return SendForgotPasswordUnknownResponse(message: error.toString());
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
  } on CognitoClientException catch (error) {
    return switch (error.code) {
      'ResourceNotFoundException' =>
        SubmitForgotPasswordFailure.invalidUserPool,
      'InvalidParameterException' =>
        SubmitForgotPasswordFailure.invalidCodeOrPassword,
      'CodeMismatchException' => SubmitForgotPasswordFailure.invalidCode,
      'ExpiredCodeException' => SubmitForgotPasswordFailure.expiredCode,
      'UserNotFoundException' => SubmitForgotPasswordFailure.noSuchUser,
      _ => SubmitForgotPasswordFailure.unknown,
    };
  } catch (_) {
    return SubmitForgotPasswordFailure.unknown;
  }
}
