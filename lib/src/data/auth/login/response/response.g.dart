// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginResponseSuccess _$$LoginResponseSuccessFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$LoginResponseSuccess',
      json,
      ($checkedConvert) {
        final val = _$LoginResponseSuccess(
          accessToken: $checkedConvert('accessToken', (v) => v as String),
          idToken: $checkedConvert('idToken', (v) => v as String),
          refreshToken: $checkedConvert('refreshToken', (v) => v as String),
          accessTokenExpiresAt:
              $checkedConvert('accessTokenExpiresAt', (v) => v as int),
          idTokenExpiresAt:
              $checkedConvert('idTokenExpiresAt', (v) => v as int),
          clockDrift: $checkedConvert('clockDrift', (v) => v as int?),
          invalidated:
              $checkedConvert('invalidated', (v) => v as bool? ?? false),
          $type: $checkedConvert('runtimeType', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {r'$type': 'runtimeType'},
    );

Map<String, dynamic> _$$LoginResponseSuccessToJson(
        _$LoginResponseSuccess instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'idToken': instance.idToken,
      'refreshToken': instance.refreshToken,
      'accessTokenExpiresAt': instance.accessTokenExpiresAt,
      'idTokenExpiresAt': instance.idTokenExpiresAt,
      'clockDrift': instance.clockDrift,
      'invalidated': instance.invalidated,
      'runtimeType': instance.$type,
    };

_$LoginResponseInvalidLogin _$$LoginResponseInvalidLoginFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$LoginResponseInvalidLogin',
      json,
      ($checkedConvert) {
        final val = _$LoginResponseInvalidLogin(
          message: $checkedConvert(
              'message', (v) => v as String? ?? "Invalid email/password"),
          $type: $checkedConvert('runtimeType', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {r'$type': 'runtimeType'},
    );

Map<String, dynamic> _$$LoginResponseInvalidLoginToJson(
        _$LoginResponseInvalidLogin instance) =>
    <String, dynamic>{
      'message': instance.message,
      'runtimeType': instance.$type,
    };

_$LoginResponseConfirmationRequired
    _$$LoginResponseConfirmationRequiredFromJson(Map<String, dynamic> json) =>
        $checkedCreate(
          r'_$LoginResponseConfirmationRequired',
          json,
          ($checkedConvert) {
            final val = _$LoginResponseConfirmationRequired(
              $type: $checkedConvert('runtimeType', (v) => v as String?),
            );
            return val;
          },
          fieldKeyMap: const {r'$type': 'runtimeType'},
        );

Map<String, dynamic> _$$LoginResponseConfirmationRequiredToJson(
        _$LoginResponseConfirmationRequired instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$LoginResponseUserNotFound _$$LoginResponseUserNotFoundFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$LoginResponseUserNotFound',
      json,
      ($checkedConvert) {
        final val = _$LoginResponseUserNotFound(
          message: $checkedConvert(
              'message', (v) => v as String? ?? "No such user exists"),
          $type: $checkedConvert('runtimeType', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {r'$type': 'runtimeType'},
    );

Map<String, dynamic> _$$LoginResponseUserNotFoundToJson(
        _$LoginResponseUserNotFound instance) =>
    <String, dynamic>{
      'message': instance.message,
      'runtimeType': instance.$type,
    };

_$LoginResponseInvalidPool _$$LoginResponseInvalidPoolFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$LoginResponseInvalidPool',
      json,
      ($checkedConvert) {
        final val = _$LoginResponseInvalidPool(
          message: $checkedConvert(
              'message', (v) => v as String? ?? "Invalid cognito credentials"),
          $type: $checkedConvert('runtimeType', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {r'$type': 'runtimeType'},
    );

Map<String, dynamic> _$$LoginResponseInvalidPoolToJson(
        _$LoginResponseInvalidPool instance) =>
    <String, dynamic>{
      'message': instance.message,
      'runtimeType': instance.$type,
    };
