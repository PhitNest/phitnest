// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cognito_credentials.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CognitoCredentialsEntity _$CognitoCredentialsEntityFromJson(
    Map<String, dynamic> json) {
  return _CognitoCredentialsEntity.fromJson(json);
}

/// @nodoc
mixin _$CognitoCredentialsEntity {
  String get userPoolId => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CognitoCredentialsEntityCopyWith<CognitoCredentialsEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CognitoCredentialsEntityCopyWith<$Res> {
  factory $CognitoCredentialsEntityCopyWith(CognitoCredentialsEntity value,
          $Res Function(CognitoCredentialsEntity) then) =
      _$CognitoCredentialsEntityCopyWithImpl<$Res, CognitoCredentialsEntity>;
  @useResult
  $Res call({String userPoolId, String clientId});
}

/// @nodoc
class _$CognitoCredentialsEntityCopyWithImpl<$Res,
        $Val extends CognitoCredentialsEntity>
    implements $CognitoCredentialsEntityCopyWith<$Res> {
  _$CognitoCredentialsEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userPoolId = null,
    Object? clientId = null,
  }) {
    return _then(_value.copyWith(
      userPoolId: null == userPoolId
          ? _value.userPoolId
          : userPoolId // ignore: cast_nullable_to_non_nullable
              as String,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CognitoCredentialsEntityCopyWith<$Res>
    implements $CognitoCredentialsEntityCopyWith<$Res> {
  factory _$$_CognitoCredentialsEntityCopyWith(
          _$_CognitoCredentialsEntity value,
          $Res Function(_$_CognitoCredentialsEntity) then) =
      __$$_CognitoCredentialsEntityCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userPoolId, String clientId});
}

/// @nodoc
class __$$_CognitoCredentialsEntityCopyWithImpl<$Res>
    extends _$CognitoCredentialsEntityCopyWithImpl<$Res,
        _$_CognitoCredentialsEntity>
    implements _$$_CognitoCredentialsEntityCopyWith<$Res> {
  __$$_CognitoCredentialsEntityCopyWithImpl(_$_CognitoCredentialsEntity _value,
      $Res Function(_$_CognitoCredentialsEntity) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userPoolId = null,
    Object? clientId = null,
  }) {
    return _then(_$_CognitoCredentialsEntity(
      userPoolId: null == userPoolId
          ? _value.userPoolId
          : userPoolId // ignore: cast_nullable_to_non_nullable
              as String,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CognitoCredentialsEntity
    with DiagnosticableTreeMixin
    implements _CognitoCredentialsEntity {
  const _$_CognitoCredentialsEntity(
      {required this.userPoolId, required this.clientId});

  factory _$_CognitoCredentialsEntity.fromJson(Map<String, dynamic> json) =>
      _$$_CognitoCredentialsEntityFromJson(json);

  @override
  final String userPoolId;
  @override
  final String clientId;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CognitoCredentialsEntity(userPoolId: $userPoolId, clientId: $clientId)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CognitoCredentialsEntity'))
      ..add(DiagnosticsProperty('userPoolId', userPoolId))
      ..add(DiagnosticsProperty('clientId', clientId));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CognitoCredentialsEntity &&
            (identical(other.userPoolId, userPoolId) ||
                other.userPoolId == userPoolId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userPoolId, clientId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CognitoCredentialsEntityCopyWith<_$_CognitoCredentialsEntity>
      get copyWith => __$$_CognitoCredentialsEntityCopyWithImpl<
          _$_CognitoCredentialsEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CognitoCredentialsEntityToJson(
      this,
    );
  }
}

abstract class _CognitoCredentialsEntity implements CognitoCredentialsEntity {
  const factory _CognitoCredentialsEntity(
      {required final String userPoolId,
      required final String clientId}) = _$_CognitoCredentialsEntity;

  factory _CognitoCredentialsEntity.fromJson(Map<String, dynamic> json) =
      _$_CognitoCredentialsEntity.fromJson;

  @override
  String get userPoolId;
  @override
  String get clientId;
  @override
  @JsonKey(ignore: true)
  _$$_CognitoCredentialsEntityCopyWith<_$_CognitoCredentialsEntity>
      get copyWith => throw _privateConstructorUsedError;
}
