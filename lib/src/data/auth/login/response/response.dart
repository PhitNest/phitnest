import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:phitnest_utils/utils.dart';

import '../../../../entities/entities.dart';

part 'response.freezed.dart';
part 'response.g.dart';

@freezed
class LoginResponse with _$LoginResponse {
  @With<IAuthCredentialsEntity>()
  const factory LoginResponse.success({
    required String accessToken,
    required String idToken,
    required String refreshToken,
    required int accessTokenExpiresAt,
    required int idTokenExpiresAt,
    required int? clockDrift,
    @Default(false) bool invalidated,
  }) = LoginResponseSuccess;

  const factory LoginResponse.invalidLogin(
          {@Default("Invalid email/password") String message}) =
      LoginResponseInvalidLogin;

  const factory LoginResponse.confirmationRequired() =
      LoginResponseConfirmationRequired;

  @Implements<Failure>()
  const factory LoginResponse.userNotFound(
          {@Default("No such user exists") String message}) =
      LoginResponseUserNotFound;

  @Implements<Failure>()
  const factory LoginResponse.invalidCognitoPool(
          {@Default("Invalid cognito credentials") String message}) =
      LoginResponseInvalidPool;

  factory LoginResponse.fromJson(Map<String, Object?> json) =>
      _$LoginResponseFromJson(json);
}
