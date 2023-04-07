import 'package:sealed_unions/sealed_unions.dart';

import '../failure.dart';

const kInvalidEmailPasswordMessage = "Invalid email/password.";
const kInvalidEmailMessage = "Invalid email.";
const kInvalidPasswordMessage = "Invalid password.";
const kConfirmationRequiredMessage = "Confirmation required.";
const kUnknownErrorMessage = "An unknown error occurred.";
const kNoSuchUserMessage = "No such user exists.";
const kInvalidUserPoolMessage = "Invalid user pool.";
const kUserAlreadyExistsMessage = "User already exists.";
const kInvalidCodeMessage = "Invalid code.";
const kInvalidRefreshToken = "Invalid refresh token.";
const kExpiredCodeMessage = "Expired code.";
const kInvalidCodeOrPasswordMessage = "Invalid code or password.";

enum LoginFailureType {
  invalidEmailPassword,
  confirmationRequired,
  noSuchUser,
  invalidUserPool,
  unknown,
}

class LoginFailure extends Failure {
  final LoginFailureType type;

  LoginFailure(this.type)
      : super(() {
          switch (type) {
            case LoginFailureType.invalidEmailPassword:
              return kInvalidEmailPasswordMessage;
            case LoginFailureType.confirmationRequired:
              return kConfirmationRequiredMessage;
            case LoginFailureType.unknown:
              return kUnknownErrorMessage;
            case LoginFailureType.noSuchUser:
              return kNoSuchUserMessage;
            case LoginFailureType.invalidUserPool:
              return kInvalidUserPoolMessage;
          }
        }());
}

enum RegistrationFailureType {
  userExists,
  invalidUserPool,
  unknown,
}

enum ValidationFailureType {
  invalidEmail,
  invalidPassword,
}

class ValidationFailure {
  final ValidationFailureType type;
  final String? issue;

  const ValidationFailure(this.type, this.issue);
}

class RegistrationFailure extends Failure {
  final Union2<RegistrationFailureType, ValidationFailure> data;

  RegistrationFailure(this.data)
      : super(
          data.join(
            (failureType) {
              switch (failureType) {
                case RegistrationFailureType.userExists:
                  return kUserAlreadyExistsMessage;
                case RegistrationFailureType.unknown:
                  return kUnknownErrorMessage;
                case RegistrationFailureType.invalidUserPool:
                  return kInvalidUserPoolMessage;
              }
            },
            (validationFailure) {
              switch (validationFailure.type) {
                case ValidationFailureType.invalidEmail:
                  return kInvalidEmailMessage;
                case ValidationFailureType.invalidPassword:
                  return kInvalidPasswordMessage;
              }
            },
          ),
        );
}

enum ForgotPasswordFailureType {
  invalidUserPool,
  invalidEmail,
  noSuchUser,
  unknown,
}

class ForgotPasswordFailure extends Failure {
  final ForgotPasswordFailureType type;

  ForgotPasswordFailure(this.type)
      : super(() {
          switch (type) {
            case ForgotPasswordFailureType.invalidUserPool:
              return kInvalidUserPoolMessage;
            case ForgotPasswordFailureType.invalidEmail:
              return kInvalidEmailMessage;
            case ForgotPasswordFailureType.noSuchUser:
              return kNoSuchUserMessage;
            case ForgotPasswordFailureType.unknown:
              return kUnknownErrorMessage;
          }
        }());
}

enum SubmitForgotPasswordFailureType {
  invalidUserPool,
  invalidEmail,
  invalidPassword,
  noSuchUser,
  invalidCodeOrPassword,
  invalidCode,
  expiredCode,
  unknown,
}

class SubmitForgotPasswordFailure extends Failure {
  final SubmitForgotPasswordFailureType type;

  SubmitForgotPasswordFailure(this.type)
      : super(() {
          switch (type) {
            case SubmitForgotPasswordFailureType.invalidUserPool:
              return kInvalidUserPoolMessage;
            case SubmitForgotPasswordFailureType.invalidEmail:
              return kInvalidEmailMessage;
            case SubmitForgotPasswordFailureType.invalidPassword:
              return kInvalidPasswordMessage;
            case SubmitForgotPasswordFailureType.noSuchUser:
              return kNoSuchUserMessage;
            case SubmitForgotPasswordFailureType.unknown:
              return kUnknownErrorMessage;
            case SubmitForgotPasswordFailureType.invalidCodeOrPassword:
              return kInvalidCodeOrPasswordMessage;
            case SubmitForgotPasswordFailureType.invalidCode:
              return kInvalidCodeMessage;
            case SubmitForgotPasswordFailureType.expiredCode:
              return kExpiredCodeMessage;
          }
        }());
}

enum RefreshSessionFailureType {
  invalidUserPool,
  noSuchUser,
  invalidToken,
  unknown,
}

class RefreshSessionFailure extends Failure {
  final RefreshSessionFailureType type;

  RefreshSessionFailure(this.type)
      : super(() {
          switch (type) {
            case RefreshSessionFailureType.invalidUserPool:
              return kInvalidUserPoolMessage;
            case RefreshSessionFailureType.unknown:
              return kUnknownErrorMessage;
            case RefreshSessionFailureType.noSuchUser:
              return kNoSuchUserMessage;
            case RefreshSessionFailureType.invalidToken:
              return kInvalidRefreshToken;
          }
        }());
}
