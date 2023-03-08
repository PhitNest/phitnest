import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:phitnest_utils/utils.dart';

part 'response.freezed.dart';
part 'response.g.dart';

@freezed
class RegisterResponse with _$RegisterResponse {
  const factory RegisterResponse.success(String userCognitoId) =
      RegisterResponseSuccess;

  @Implements<Failure>()
  const factory RegisterResponse.invalidPassword({
    required String message,
  }) = RegisterResponseInvalidPassword;

  @Implements<Failure>()
  const factory RegisterResponse.userExists({
    @Default("A user with this email already exists") String message,
  }) = RegisterResponseUserExists;

  @Implements<Failure>()
  const factory RegisterResponse.invalidEmail({
    required String message,
  }) = RegisterResponseInvalidEmail;

  @Implements<Failure>()
  const factory RegisterResponse.invalidCognitoPool({
    @Default("Invalid cognito credentials") String message,
  }) = RegisterResponseInvalidPool;

  factory RegisterResponse.fromJson(Map<String, Object?> json) =>
      _$RegisterResponseFromJson(json);
}
