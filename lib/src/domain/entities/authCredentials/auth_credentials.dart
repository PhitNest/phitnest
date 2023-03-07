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
  }) = _AuthCredentialsEntity;

  factory AuthCredentialsEntity.fromJson(Map<String, Object?> json) =>
      _$AuthCredentialsEntityFromJson(json);
}
