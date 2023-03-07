import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'auth_credentials.freezed.dart';
part 'auth_credentials.g.dart';

@freezed
class AuthCredentialsEntity with _$AuthCredentialsEntity {
  const factory AuthCredentialsEntity({
    required String accessToken,
    required String idToken,
    required String refreshToken,
    required int accessTokenExpiresAt,
    required int idTokenExpiresAt,
    int? clockDrift,
    @Default(false) bool invalidated,
  }) = _AuthCredentialsEntity;

  factory AuthCredentialsEntity.fromJson(Map<String, Object?> json) =>
      _$AuthCredentialsEntityFromJson(json);

  const AuthCredentialsEntity._();

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
