// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserEntity _$$_UserEntityFromJson(Map<String, dynamic> json) =>
    _$_UserEntity(
      id: json['id'] as String,
      email: json['email'] as String,
      gymId: json['gymId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      confirmed: json['confirmed'] as bool,
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
