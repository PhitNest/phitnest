import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:phitnest_utils/utils.dart';

part 'response.freezed.dart';
part 'response.g.dart';

mixin AuthCredentials on LoginResponseSuccess {
  /// Checks to see if the session is still valid based on session expiry information found
  /// in tokens and the current time (adjusted with clock drift)
  bool isValid() {
    if (invalidated) {
      return false;
    }
    final now = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
    final adjusted = now - clockDrift!;

    return adjusted < accessTokenExpiresAt && adjusted < idTokenExpiresAt;
  }
}

@freezed
class LoginResponse with _$LoginResponse, Serializable {
  const factory LoginResponse.success({
    required String accessToken,
    required String idToken,
    required String refreshToken,
    required int accessTokenExpiresAt,
    required int idTokenExpiresAt,
    required int? clockDrift,
    @Default(false) bool invalidated,
  }) = LoginResponseSuccess;

  const factory LoginResponse.sandbox() = LoginResponseSandbox;

  @Implements<Failure>()
  const factory LoginResponse.invalidLogin({
    @Default("Invalid email/password") String message,
  }) = LoginResponseInvalidLogin;

  @Implements<Failure>()
  const factory LoginResponse.confirmationRequired({
    @Default("You are not confirmed") String message,
  }) = LoginResponseConfirmationRequired;

  @Implements<Failure>()
  const factory LoginResponse.userNotFound({
    @Default("No such user exists") String message,
  }) = LoginResponseUserNotFound;

  @Implements<Failure>()
  const factory LoginResponse.unknown({
    @Default("An unknown error has occurred") String message,
  }) = LoginResponseUserUnknown;

  @Implements<Failure>()
  const factory LoginResponse.invalidCognitoPool({
    @Default("Invalid cognito credentials") String message,
  }) = LoginResponseInvalidPool;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
