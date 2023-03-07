// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cognito_credentials.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CognitoCredentialsEntity _$$_CognitoCredentialsEntityFromJson(
        Map<String, dynamic> json) =>
    _$_CognitoCredentialsEntity(
      userPoolId: json['userPoolId'] as String,
      clientId: json['clientId'] as String,
    );

Map<String, dynamic> _$$_CognitoCredentialsEntityToJson(
        _$_CognitoCredentialsEntity instance) =>
    <String, dynamic>{
      'userPoolId': instance.userPoolId,
      'clientId': instance.clientId,
    };
