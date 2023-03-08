import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:phitnest_utils/utils.dart';

part 'cognito_credentials.freezed.dart';
part 'cognito_credentials.g.dart';

@freezed
class CognitoCredentialsEntity with _$CognitoCredentialsEntity, Serializable {
  const CognitoCredentialsEntity._();

  const factory CognitoCredentialsEntity({
    required String userPoolId,
    required String clientId,
  }) = _CognitoCredentialsEntity;

  const factory CognitoCredentialsEntity.sandbox({
    @Default("sandbox") String userPoolId,
    @Default("sandbox") String clientId,
  }) = CognitoCredentialsSandboxEntity;

  factory CognitoCredentialsEntity.fromJson(Map<String, Object?> json) =>
      _$CognitoCredentialsEntityFromJson(json);
}
