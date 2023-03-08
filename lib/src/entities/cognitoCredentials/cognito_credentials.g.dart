// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cognito_credentials.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CognitoCredentialsEntity _$$_CognitoCredentialsEntityFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$_CognitoCredentialsEntity',
      json,
      ($checkedConvert) {
        final val = _$_CognitoCredentialsEntity(
          userPoolId: $checkedConvert('userPoolId', (v) => v as String),
          clientId: $checkedConvert('clientId', (v) => v as String),
          $type: $checkedConvert('runtimeType', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {r'$type': 'runtimeType'},
    );

Map<String, dynamic> _$$_CognitoCredentialsEntityToJson(
        _$_CognitoCredentialsEntity instance) =>
    <String, dynamic>{
      'userPoolId': instance.userPoolId,
      'clientId': instance.clientId,
      'runtimeType': instance.$type,
    };

_$CognitoCredentialsSandboxEntity _$$CognitoCredentialsSandboxEntityFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$CognitoCredentialsSandboxEntity',
      json,
      ($checkedConvert) {
        final val = _$CognitoCredentialsSandboxEntity(
          userPoolId:
              $checkedConvert('userPoolId', (v) => v as String? ?? "sandbox"),
          clientId:
              $checkedConvert('clientId', (v) => v as String? ?? "sandbox"),
          $type: $checkedConvert('runtimeType', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {r'$type': 'runtimeType'},
    );

Map<String, dynamic> _$$CognitoCredentialsSandboxEntityToJson(
        _$CognitoCredentialsSandboxEntity instance) =>
    <String, dynamic>{
      'userPoolId': instance.userPoolId,
      'clientId': instance.clientId,
      'runtimeType': instance.$type,
    };
