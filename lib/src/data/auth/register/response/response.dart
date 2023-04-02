import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:phitnest_utils/utils.dart';

part 'response.freezed.dart';

@freezed
class RegisterResponse with _$RegisterResponse {
  const factory RegisterResponse.success(String userCognitoId) =
      RegisterResponseSuccess;

  const factory RegisterResponse.sandbox() = RegisterResponseSandbox;

  @Implements<Failure>()
  const factory RegisterResponse.invalidPassword({
    @Default("Please enter a valid password") String message,
  }) = RegisterResponseInvalidPassword;

  @Implements<Failure>()
  const factory RegisterResponse.userExists({
    @Default("A user with this email already exists") String message,
  }) = RegisterResponseUserExists;

  @Implements<Failure>()
  const factory RegisterResponse.unknown({
    @Default("An unknown error has occurred") String message,
  }) = RegisterResponseUnknown;

  @Implements<Failure>()
  const factory RegisterResponse.invalidEmail({
    @Default("Please enter a valid email") String message,
  }) = RegisterResponseInvalidEmail;

  @Implements<Failure>()
  const factory RegisterResponse.invalidCognitoPool({
    @Default("Invalid cognito credentials") String message,
  }) = RegisterResponseInvalidPool;
}
