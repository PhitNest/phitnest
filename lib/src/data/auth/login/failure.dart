import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'failure.freezed.dart';

@freezed
class LoginFailure with _$LoginFailure {
  const factory LoginFailure.invalidLogin() = LoginFailureInvalidLogin;
  const factory LoginFailure.unknown() = LoginFailureUnknown;
  const factory LoginFailure.confirmationRequired() =
      LoginFailureConfirmationRequired;
  const factory LoginFailure.userNotFound() = LoginFailureUserNotFound;
  const factory LoginFailure.invalidCognitoPool() = LoginFailureInvalidPool;
}
