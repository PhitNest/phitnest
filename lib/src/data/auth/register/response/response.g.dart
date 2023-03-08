// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegisterResponseSuccess _$$RegisterResponseSuccessFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$RegisterResponseSuccess',
      json,
      ($checkedConvert) {
        final val = _$RegisterResponseSuccess(
          $checkedConvert('userCognitoId', (v) => v as String),
          $type: $checkedConvert('runtimeType', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {r'$type': 'runtimeType'},
    );

Map<String, dynamic> _$$RegisterResponseSuccessToJson(
        _$RegisterResponseSuccess instance) =>
    <String, dynamic>{
      'userCognitoId': instance.userCognitoId,
      'runtimeType': instance.$type,
    };

_$RegisterResponseInvalidPassword _$$RegisterResponseInvalidPasswordFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$RegisterResponseInvalidPassword',
      json,
      ($checkedConvert) {
        final val = _$RegisterResponseInvalidPassword(
          message: $checkedConvert('message', (v) => v as String),
          $type: $checkedConvert('runtimeType', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {r'$type': 'runtimeType'},
    );

Map<String, dynamic> _$$RegisterResponseInvalidPasswordToJson(
        _$RegisterResponseInvalidPassword instance) =>
    <String, dynamic>{
      'message': instance.message,
      'runtimeType': instance.$type,
    };

_$RegisterResponseUserExists _$$RegisterResponseUserExistsFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$RegisterResponseUserExists',
      json,
      ($checkedConvert) {
        final val = _$RegisterResponseUserExists(
          message: $checkedConvert('message',
              (v) => v as String? ?? "A user with this email already exists"),
          $type: $checkedConvert('runtimeType', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {r'$type': 'runtimeType'},
    );

Map<String, dynamic> _$$RegisterResponseUserExistsToJson(
        _$RegisterResponseUserExists instance) =>
    <String, dynamic>{
      'message': instance.message,
      'runtimeType': instance.$type,
    };

_$RegisterResponseInvalidEmail _$$RegisterResponseInvalidEmailFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$RegisterResponseInvalidEmail',
      json,
      ($checkedConvert) {
        final val = _$RegisterResponseInvalidEmail(
          message: $checkedConvert('message', (v) => v as String),
          $type: $checkedConvert('runtimeType', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {r'$type': 'runtimeType'},
    );

Map<String, dynamic> _$$RegisterResponseInvalidEmailToJson(
        _$RegisterResponseInvalidEmail instance) =>
    <String, dynamic>{
      'message': instance.message,
      'runtimeType': instance.$type,
    };

_$RegisterResponseInvalidPool _$$RegisterResponseInvalidPoolFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$RegisterResponseInvalidPool',
      json,
      ($checkedConvert) {
        final val = _$RegisterResponseInvalidPool(
          message: $checkedConvert(
              'message', (v) => v as String? ?? "Invalid cognito credentials"),
          $type: $checkedConvert('runtimeType', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {r'$type': 'runtimeType'},
    );

Map<String, dynamic> _$$RegisterResponseInvalidPoolToJson(
        _$RegisterResponseInvalidPool instance) =>
    <String, dynamic>{
      'message': instance.message,
      'runtimeType': instance.$type,
    };
