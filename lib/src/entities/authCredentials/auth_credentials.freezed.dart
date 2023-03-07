// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_credentials.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AuthCredentialsEntity _$AuthCredentialsEntityFromJson(
    Map<String, dynamic> json) {
  return _AuthCredentialsEntity.fromJson(json);
}

/// @nodoc
mixin _$AuthCredentialsEntity {
  String get accessToken => throw _privateConstructorUsedError;
  String get idToken => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;
  int get accessTokenExpiresAt => throw _privateConstructorUsedError;
  int get idTokenExpiresAt => throw _privateConstructorUsedError;
  int? get clockDrift => throw _privateConstructorUsedError;
  bool get invalidated => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthCredentialsEntityCopyWith<AuthCredentialsEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthCredentialsEntityCopyWith<$Res> {
  factory $AuthCredentialsEntityCopyWith(AuthCredentialsEntity value,
          $Res Function(AuthCredentialsEntity) then) =
      _$AuthCredentialsEntityCopyWithImpl<$Res, AuthCredentialsEntity>;
  @useResult
  $Res call(
      {String accessToken,
      String idToken,
      String refreshToken,
      int accessTokenExpiresAt,
      int idTokenExpiresAt,
      int? clockDrift,
      bool invalidated});
}

/// @nodoc
class _$AuthCredentialsEntityCopyWithImpl<$Res,
        $Val extends AuthCredentialsEntity>
    implements $AuthCredentialsEntityCopyWith<$Res> {
  _$AuthCredentialsEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? idToken = null,
    Object? refreshToken = null,
    Object? accessTokenExpiresAt = null,
    Object? idTokenExpiresAt = null,
    Object? clockDrift = freezed,
    Object? invalidated = null,
  }) {
    return _then(_value.copyWith(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      idToken: null == idToken
          ? _value.idToken
          : idToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      accessTokenExpiresAt: null == accessTokenExpiresAt
          ? _value.accessTokenExpiresAt
          : accessTokenExpiresAt // ignore: cast_nullable_to_non_nullable
              as int,
      idTokenExpiresAt: null == idTokenExpiresAt
          ? _value.idTokenExpiresAt
          : idTokenExpiresAt // ignore: cast_nullable_to_non_nullable
              as int,
      clockDrift: freezed == clockDrift
          ? _value.clockDrift
          : clockDrift // ignore: cast_nullable_to_non_nullable
              as int?,
      invalidated: null == invalidated
          ? _value.invalidated
          : invalidated // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AuthCredentialsEntityCopyWith<$Res>
    implements $AuthCredentialsEntityCopyWith<$Res> {
  factory _$$_AuthCredentialsEntityCopyWith(_$_AuthCredentialsEntity value,
          $Res Function(_$_AuthCredentialsEntity) then) =
      __$$_AuthCredentialsEntityCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String accessToken,
      String idToken,
      String refreshToken,
      int accessTokenExpiresAt,
      int idTokenExpiresAt,
      int? clockDrift,
      bool invalidated});
}

/// @nodoc
class __$$_AuthCredentialsEntityCopyWithImpl<$Res>
    extends _$AuthCredentialsEntityCopyWithImpl<$Res, _$_AuthCredentialsEntity>
    implements _$$_AuthCredentialsEntityCopyWith<$Res> {
  __$$_AuthCredentialsEntityCopyWithImpl(_$_AuthCredentialsEntity _value,
      $Res Function(_$_AuthCredentialsEntity) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? idToken = null,
    Object? refreshToken = null,
    Object? accessTokenExpiresAt = null,
    Object? idTokenExpiresAt = null,
    Object? clockDrift = freezed,
    Object? invalidated = null,
  }) {
    return _then(_$_AuthCredentialsEntity(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      idToken: null == idToken
          ? _value.idToken
          : idToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      accessTokenExpiresAt: null == accessTokenExpiresAt
          ? _value.accessTokenExpiresAt
          : accessTokenExpiresAt // ignore: cast_nullable_to_non_nullable
              as int,
      idTokenExpiresAt: null == idTokenExpiresAt
          ? _value.idTokenExpiresAt
          : idTokenExpiresAt // ignore: cast_nullable_to_non_nullable
              as int,
      clockDrift: freezed == clockDrift
          ? _value.clockDrift
          : clockDrift // ignore: cast_nullable_to_non_nullable
              as int?,
      invalidated: null == invalidated
          ? _value.invalidated
          : invalidated // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AuthCredentialsEntity extends _AuthCredentialsEntity
    with DiagnosticableTreeMixin {
  const _$_AuthCredentialsEntity(
      {required this.accessToken,
      required this.idToken,
      required this.refreshToken,
      required this.accessTokenExpiresAt,
      required this.idTokenExpiresAt,
      this.clockDrift,
      this.invalidated = false})
      : super._();

  factory _$_AuthCredentialsEntity.fromJson(Map<String, dynamic> json) =>
      _$$_AuthCredentialsEntityFromJson(json);

  @override
  final String accessToken;
  @override
  final String idToken;
  @override
  final String refreshToken;
  @override
  final int accessTokenExpiresAt;
  @override
  final int idTokenExpiresAt;
  @override
  final int? clockDrift;
  @override
  @JsonKey()
  final bool invalidated;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AuthCredentialsEntity(accessToken: $accessToken, idToken: $idToken, refreshToken: $refreshToken, accessTokenExpiresAt: $accessTokenExpiresAt, idTokenExpiresAt: $idTokenExpiresAt, clockDrift: $clockDrift, invalidated: $invalidated)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AuthCredentialsEntity'))
      ..add(DiagnosticsProperty('accessToken', accessToken))
      ..add(DiagnosticsProperty('idToken', idToken))
      ..add(DiagnosticsProperty('refreshToken', refreshToken))
      ..add(DiagnosticsProperty('accessTokenExpiresAt', accessTokenExpiresAt))
      ..add(DiagnosticsProperty('idTokenExpiresAt', idTokenExpiresAt))
      ..add(DiagnosticsProperty('clockDrift', clockDrift))
      ..add(DiagnosticsProperty('invalidated', invalidated));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AuthCredentialsEntity &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.idToken, idToken) || other.idToken == idToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.accessTokenExpiresAt, accessTokenExpiresAt) ||
                other.accessTokenExpiresAt == accessTokenExpiresAt) &&
            (identical(other.idTokenExpiresAt, idTokenExpiresAt) ||
                other.idTokenExpiresAt == idTokenExpiresAt) &&
            (identical(other.clockDrift, clockDrift) ||
                other.clockDrift == clockDrift) &&
            (identical(other.invalidated, invalidated) ||
                other.invalidated == invalidated));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      accessToken,
      idToken,
      refreshToken,
      accessTokenExpiresAt,
      idTokenExpiresAt,
      clockDrift,
      invalidated);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AuthCredentialsEntityCopyWith<_$_AuthCredentialsEntity> get copyWith =>
      __$$_AuthCredentialsEntityCopyWithImpl<_$_AuthCredentialsEntity>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AuthCredentialsEntityToJson(
      this,
    );
  }
}

abstract class _AuthCredentialsEntity extends AuthCredentialsEntity {
  const factory _AuthCredentialsEntity(
      {required final String accessToken,
      required final String idToken,
      required final String refreshToken,
      required final int accessTokenExpiresAt,
      required final int idTokenExpiresAt,
      final int? clockDrift,
      final bool invalidated}) = _$_AuthCredentialsEntity;
  const _AuthCredentialsEntity._() : super._();

  factory _AuthCredentialsEntity.fromJson(Map<String, dynamic> json) =
      _$_AuthCredentialsEntity.fromJson;

  @override
  String get accessToken;
  @override
  String get idToken;
  @override
  String get refreshToken;
  @override
  int get accessTokenExpiresAt;
  @override
  int get idTokenExpiresAt;
  @override
  int? get clockDrift;
  @override
  bool get invalidated;
  @override
  @JsonKey(ignore: true)
  _$$_AuthCredentialsEntityCopyWith<_$_AuthCredentialsEntity> get copyWith =>
      throw _privateConstructorUsedError;
}
