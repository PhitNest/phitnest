// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_credentials.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AuthCredentialsEntity _$$_AuthCredentialsEntityFromJson(
        Map<String, dynamic> json) =>
    _$_AuthCredentialsEntity(
      accessToken: json['accessToken'] as String,
      idToken: json['idToken'] as String,
      refreshToken: json['refreshToken'] as String,
      accessTokenExpiresAt: json['accessTokenExpiresAt'] as int,
      idTokenExpiresAt: json['idTokenExpiresAt'] as int,
      clockDrift: json['clockDrift'] as int?,
      invalidated: json['invalidated'] as bool? ?? false,
    );

Map<String, dynamic> _$$_AuthCredentialsEntityToJson(
        _$_AuthCredentialsEntity instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'idToken': instance.idToken,
      'refreshToken': instance.refreshToken,
      'accessTokenExpiresAt': instance.accessTokenExpiresAt,
      'idTokenExpiresAt': instance.idTokenExpiresAt,
      'clockDrift': instance.clockDrift,
      'invalidated': instance.invalidated,
    };
