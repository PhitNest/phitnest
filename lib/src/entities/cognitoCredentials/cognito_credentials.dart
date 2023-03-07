import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'cognito_credentials.freezed.dart';
part 'cognito_credentials.g.dart';

@freezed
class CognitoCredentialsEntity with _$CognitoCredentialsEntity {
  const factory CognitoCredentialsEntity({
    required String userPoolId,
    required String clientId,
  }) = _CognitoCredentialsEntity;

  factory CognitoCredentialsEntity.fromJson(Map<String, Object?> json) =>
      _$CognitoCredentialsEntityFromJson(json);
}
