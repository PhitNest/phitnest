// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserEntity _$$_UserEntityFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$_UserEntity',
      json,
      ($checkedConvert) {
        final val = _$_UserEntity(
          id: $checkedConvert('id', (v) => v as String),
          email: $checkedConvert('email', (v) => v as String),
          gymId: $checkedConvert('gymId', (v) => v as String),
          firstName: $checkedConvert('firstName', (v) => v as String),
          lastName: $checkedConvert('lastName', (v) => v as String),
          confirmed: $checkedConvert('confirmed', (v) => v as bool),
        );
        return val;
      },
    );

Map<String, dynamic> _$$_UserEntityToJson(_$_UserEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'gymId': instance.gymId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'confirmed': instance.confirmed,
    };
