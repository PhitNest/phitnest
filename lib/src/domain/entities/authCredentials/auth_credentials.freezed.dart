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
  $Res call({String accessToken, String idToken, String refreshToken});
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
  $Res call({String accessToken, String idToken, String refreshToken});
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AuthCredentialsEntity
    with DiagnosticableTreeMixin
    implements _AuthCredentialsEntity {
  const _$_AuthCredentialsEntity(
      {required this.accessToken,
      required this.idToken,
      required this.refreshToken});

  factory _$_AuthCredentialsEntity.fromJson(Map<String, dynamic> json) =>
      _$$_AuthCredentialsEntityFromJson(json);

  @override
  final String accessToken;
  @override
  final String idToken;
  @override
  final String refreshToken;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AuthCredentialsEntity(accessToken: $accessToken, idToken: $idToken, refreshToken: $refreshToken)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AuthCredentialsEntity'))
      ..add(DiagnosticsProperty('accessToken', accessToken))
      ..add(DiagnosticsProperty('idToken', idToken))
      ..add(DiagnosticsProperty('refreshToken', refreshToken));
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
                other.refreshToken == refreshToken));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, accessToken, idToken, refreshToken);

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

abstract class _AuthCredentialsEntity implements AuthCredentialsEntity {
  const factory _AuthCredentialsEntity(
      {required final String accessToken,
      required final String idToken,
      required final String refreshToken}) = _$_AuthCredentialsEntity;

  factory _AuthCredentialsEntity.fromJson(Map<String, dynamic> json) =
      _$_AuthCredentialsEntity.fromJson;

  @override
  String get accessToken;
  @override
  String get idToken;
  @override
  String get refreshToken;
  @override
  @JsonKey(ignore: true)
  _$$_AuthCredentialsEntityCopyWith<_$_AuthCredentialsEntity> get copyWith =>
      throw _privateConstructorUsedError;
}
