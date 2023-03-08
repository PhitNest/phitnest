// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

RegisterResponse _$RegisterResponseFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'success':
      return RegisterResponseSuccess.fromJson(json);
    case 'invalidPassword':
      return RegisterResponseInvalidPassword.fromJson(json);
    case 'userExists':
      return RegisterResponseUserExists.fromJson(json);
    case 'invalidEmail':
      return RegisterResponseInvalidEmail.fromJson(json);
    case 'invalidCognitoPool':
      return RegisterResponseInvalidPool.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'RegisterResponse',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$RegisterResponse {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String userCognitoId) success,
    required TResult Function(String message) invalidPassword,
    required TResult Function(String message) userExists,
    required TResult Function(String message) invalidEmail,
    required TResult Function(String message) invalidCognitoPool,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String userCognitoId)? success,
    TResult? Function(String message)? invalidPassword,
    TResult? Function(String message)? userExists,
    TResult? Function(String message)? invalidEmail,
    TResult? Function(String message)? invalidCognitoPool,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String userCognitoId)? success,
    TResult Function(String message)? invalidPassword,
    TResult Function(String message)? userExists,
    TResult Function(String message)? invalidEmail,
    TResult Function(String message)? invalidCognitoPool,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RegisterResponseSuccess value) success,
    required TResult Function(RegisterResponseInvalidPassword value)
        invalidPassword,
    required TResult Function(RegisterResponseUserExists value) userExists,
    required TResult Function(RegisterResponseInvalidEmail value) invalidEmail,
    required TResult Function(RegisterResponseInvalidPool value)
        invalidCognitoPool,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RegisterResponseSuccess value)? success,
    TResult? Function(RegisterResponseInvalidPassword value)? invalidPassword,
    TResult? Function(RegisterResponseUserExists value)? userExists,
    TResult? Function(RegisterResponseInvalidEmail value)? invalidEmail,
    TResult? Function(RegisterResponseInvalidPool value)? invalidCognitoPool,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RegisterResponseSuccess value)? success,
    TResult Function(RegisterResponseInvalidPassword value)? invalidPassword,
    TResult Function(RegisterResponseUserExists value)? userExists,
    TResult Function(RegisterResponseInvalidEmail value)? invalidEmail,
    TResult Function(RegisterResponseInvalidPool value)? invalidCognitoPool,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterResponseCopyWith<$Res> {
  factory $RegisterResponseCopyWith(
          RegisterResponse value, $Res Function(RegisterResponse) then) =
      _$RegisterResponseCopyWithImpl<$Res, RegisterResponse>;
}

/// @nodoc
class _$RegisterResponseCopyWithImpl<$Res, $Val extends RegisterResponse>
    implements $RegisterResponseCopyWith<$Res> {
  _$RegisterResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$RegisterResponseSuccessCopyWith<$Res> {
  factory _$$RegisterResponseSuccessCopyWith(_$RegisterResponseSuccess value,
          $Res Function(_$RegisterResponseSuccess) then) =
      __$$RegisterResponseSuccessCopyWithImpl<$Res>;
  @useResult
  $Res call({String userCognitoId});
}

/// @nodoc
class __$$RegisterResponseSuccessCopyWithImpl<$Res>
    extends _$RegisterResponseCopyWithImpl<$Res, _$RegisterResponseSuccess>
    implements _$$RegisterResponseSuccessCopyWith<$Res> {
  __$$RegisterResponseSuccessCopyWithImpl(_$RegisterResponseSuccess _value,
      $Res Function(_$RegisterResponseSuccess) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userCognitoId = null,
  }) {
    return _then(_$RegisterResponseSuccess(
      null == userCognitoId
          ? _value.userCognitoId
          : userCognitoId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterResponseSuccess
    with DiagnosticableTreeMixin
    implements RegisterResponseSuccess {
  const _$RegisterResponseSuccess(this.userCognitoId, {final String? $type})
      : $type = $type ?? 'success';

  factory _$RegisterResponseSuccess.fromJson(Map<String, dynamic> json) =>
      _$$RegisterResponseSuccessFromJson(json);

  @override
  final String userCognitoId;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RegisterResponse.success(userCognitoId: $userCognitoId)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RegisterResponse.success'))
      ..add(DiagnosticsProperty('userCognitoId', userCognitoId));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterResponseSuccess &&
            (identical(other.userCognitoId, userCognitoId) ||
                other.userCognitoId == userCognitoId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userCognitoId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterResponseSuccessCopyWith<_$RegisterResponseSuccess> get copyWith =>
      __$$RegisterResponseSuccessCopyWithImpl<_$RegisterResponseSuccess>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String userCognitoId) success,
    required TResult Function(String message) invalidPassword,
    required TResult Function(String message) userExists,
    required TResult Function(String message) invalidEmail,
    required TResult Function(String message) invalidCognitoPool,
  }) {
    return success(userCognitoId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String userCognitoId)? success,
    TResult? Function(String message)? invalidPassword,
    TResult? Function(String message)? userExists,
    TResult? Function(String message)? invalidEmail,
    TResult? Function(String message)? invalidCognitoPool,
  }) {
    return success?.call(userCognitoId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String userCognitoId)? success,
    TResult Function(String message)? invalidPassword,
    TResult Function(String message)? userExists,
    TResult Function(String message)? invalidEmail,
    TResult Function(String message)? invalidCognitoPool,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(userCognitoId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RegisterResponseSuccess value) success,
    required TResult Function(RegisterResponseInvalidPassword value)
        invalidPassword,
    required TResult Function(RegisterResponseUserExists value) userExists,
    required TResult Function(RegisterResponseInvalidEmail value) invalidEmail,
    required TResult Function(RegisterResponseInvalidPool value)
        invalidCognitoPool,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RegisterResponseSuccess value)? success,
    TResult? Function(RegisterResponseInvalidPassword value)? invalidPassword,
    TResult? Function(RegisterResponseUserExists value)? userExists,
    TResult? Function(RegisterResponseInvalidEmail value)? invalidEmail,
    TResult? Function(RegisterResponseInvalidPool value)? invalidCognitoPool,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RegisterResponseSuccess value)? success,
    TResult Function(RegisterResponseInvalidPassword value)? invalidPassword,
    TResult Function(RegisterResponseUserExists value)? userExists,
    TResult Function(RegisterResponseInvalidEmail value)? invalidEmail,
    TResult Function(RegisterResponseInvalidPool value)? invalidCognitoPool,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterResponseSuccessToJson(
      this,
    );
  }
}

abstract class RegisterResponseSuccess implements RegisterResponse {
  const factory RegisterResponseSuccess(final String userCognitoId) =
      _$RegisterResponseSuccess;

  factory RegisterResponseSuccess.fromJson(Map<String, dynamic> json) =
      _$RegisterResponseSuccess.fromJson;

  String get userCognitoId;
  @JsonKey(ignore: true)
  _$$RegisterResponseSuccessCopyWith<_$RegisterResponseSuccess> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RegisterResponseInvalidPasswordCopyWith<$Res> {
  factory _$$RegisterResponseInvalidPasswordCopyWith(
          _$RegisterResponseInvalidPassword value,
          $Res Function(_$RegisterResponseInvalidPassword) then) =
      __$$RegisterResponseInvalidPasswordCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$RegisterResponseInvalidPasswordCopyWithImpl<$Res>
    extends _$RegisterResponseCopyWithImpl<$Res,
        _$RegisterResponseInvalidPassword>
    implements _$$RegisterResponseInvalidPasswordCopyWith<$Res> {
  __$$RegisterResponseInvalidPasswordCopyWithImpl(
      _$RegisterResponseInvalidPassword _value,
      $Res Function(_$RegisterResponseInvalidPassword) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$RegisterResponseInvalidPassword(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterResponseInvalidPassword
    with DiagnosticableTreeMixin
    implements RegisterResponseInvalidPassword {
  const _$RegisterResponseInvalidPassword(
      {required this.message, final String? $type})
      : $type = $type ?? 'invalidPassword';

  factory _$RegisterResponseInvalidPassword.fromJson(
          Map<String, dynamic> json) =>
      _$$RegisterResponseInvalidPasswordFromJson(json);

  @override
  final String message;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RegisterResponse.invalidPassword(message: $message)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RegisterResponse.invalidPassword'))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterResponseInvalidPassword &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterResponseInvalidPasswordCopyWith<_$RegisterResponseInvalidPassword>
      get copyWith => __$$RegisterResponseInvalidPasswordCopyWithImpl<
          _$RegisterResponseInvalidPassword>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String userCognitoId) success,
    required TResult Function(String message) invalidPassword,
    required TResult Function(String message) userExists,
    required TResult Function(String message) invalidEmail,
    required TResult Function(String message) invalidCognitoPool,
  }) {
    return invalidPassword(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String userCognitoId)? success,
    TResult? Function(String message)? invalidPassword,
    TResult? Function(String message)? userExists,
    TResult? Function(String message)? invalidEmail,
    TResult? Function(String message)? invalidCognitoPool,
  }) {
    return invalidPassword?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String userCognitoId)? success,
    TResult Function(String message)? invalidPassword,
    TResult Function(String message)? userExists,
    TResult Function(String message)? invalidEmail,
    TResult Function(String message)? invalidCognitoPool,
    required TResult orElse(),
  }) {
    if (invalidPassword != null) {
      return invalidPassword(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RegisterResponseSuccess value) success,
    required TResult Function(RegisterResponseInvalidPassword value)
        invalidPassword,
    required TResult Function(RegisterResponseUserExists value) userExists,
    required TResult Function(RegisterResponseInvalidEmail value) invalidEmail,
    required TResult Function(RegisterResponseInvalidPool value)
        invalidCognitoPool,
  }) {
    return invalidPassword(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RegisterResponseSuccess value)? success,
    TResult? Function(RegisterResponseInvalidPassword value)? invalidPassword,
    TResult? Function(RegisterResponseUserExists value)? userExists,
    TResult? Function(RegisterResponseInvalidEmail value)? invalidEmail,
    TResult? Function(RegisterResponseInvalidPool value)? invalidCognitoPool,
  }) {
    return invalidPassword?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RegisterResponseSuccess value)? success,
    TResult Function(RegisterResponseInvalidPassword value)? invalidPassword,
    TResult Function(RegisterResponseUserExists value)? userExists,
    TResult Function(RegisterResponseInvalidEmail value)? invalidEmail,
    TResult Function(RegisterResponseInvalidPool value)? invalidCognitoPool,
    required TResult orElse(),
  }) {
    if (invalidPassword != null) {
      return invalidPassword(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterResponseInvalidPasswordToJson(
      this,
    );
  }
}

abstract class RegisterResponseInvalidPassword
    implements RegisterResponse, Failure {
  const factory RegisterResponseInvalidPassword(
      {required final String message}) = _$RegisterResponseInvalidPassword;

  factory RegisterResponseInvalidPassword.fromJson(Map<String, dynamic> json) =
      _$RegisterResponseInvalidPassword.fromJson;

  String get message;
  @JsonKey(ignore: true)
  _$$RegisterResponseInvalidPasswordCopyWith<_$RegisterResponseInvalidPassword>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RegisterResponseUserExistsCopyWith<$Res> {
  factory _$$RegisterResponseUserExistsCopyWith(
          _$RegisterResponseUserExists value,
          $Res Function(_$RegisterResponseUserExists) then) =
      __$$RegisterResponseUserExistsCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$RegisterResponseUserExistsCopyWithImpl<$Res>
    extends _$RegisterResponseCopyWithImpl<$Res, _$RegisterResponseUserExists>
    implements _$$RegisterResponseUserExistsCopyWith<$Res> {
  __$$RegisterResponseUserExistsCopyWithImpl(
      _$RegisterResponseUserExists _value,
      $Res Function(_$RegisterResponseUserExists) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$RegisterResponseUserExists(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterResponseUserExists
    with DiagnosticableTreeMixin
    implements RegisterResponseUserExists {
  const _$RegisterResponseUserExists(
      {this.message = "A user with this email already exists",
      final String? $type})
      : $type = $type ?? 'userExists';

  factory _$RegisterResponseUserExists.fromJson(Map<String, dynamic> json) =>
      _$$RegisterResponseUserExistsFromJson(json);

  @override
  @JsonKey()
  final String message;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RegisterResponse.userExists(message: $message)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RegisterResponse.userExists'))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterResponseUserExists &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterResponseUserExistsCopyWith<_$RegisterResponseUserExists>
      get copyWith => __$$RegisterResponseUserExistsCopyWithImpl<
          _$RegisterResponseUserExists>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String userCognitoId) success,
    required TResult Function(String message) invalidPassword,
    required TResult Function(String message) userExists,
    required TResult Function(String message) invalidEmail,
    required TResult Function(String message) invalidCognitoPool,
  }) {
    return userExists(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String userCognitoId)? success,
    TResult? Function(String message)? invalidPassword,
    TResult? Function(String message)? userExists,
    TResult? Function(String message)? invalidEmail,
    TResult? Function(String message)? invalidCognitoPool,
  }) {
    return userExists?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String userCognitoId)? success,
    TResult Function(String message)? invalidPassword,
    TResult Function(String message)? userExists,
    TResult Function(String message)? invalidEmail,
    TResult Function(String message)? invalidCognitoPool,
    required TResult orElse(),
  }) {
    if (userExists != null) {
      return userExists(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RegisterResponseSuccess value) success,
    required TResult Function(RegisterResponseInvalidPassword value)
        invalidPassword,
    required TResult Function(RegisterResponseUserExists value) userExists,
    required TResult Function(RegisterResponseInvalidEmail value) invalidEmail,
    required TResult Function(RegisterResponseInvalidPool value)
        invalidCognitoPool,
  }) {
    return userExists(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RegisterResponseSuccess value)? success,
    TResult? Function(RegisterResponseInvalidPassword value)? invalidPassword,
    TResult? Function(RegisterResponseUserExists value)? userExists,
    TResult? Function(RegisterResponseInvalidEmail value)? invalidEmail,
    TResult? Function(RegisterResponseInvalidPool value)? invalidCognitoPool,
  }) {
    return userExists?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RegisterResponseSuccess value)? success,
    TResult Function(RegisterResponseInvalidPassword value)? invalidPassword,
    TResult Function(RegisterResponseUserExists value)? userExists,
    TResult Function(RegisterResponseInvalidEmail value)? invalidEmail,
    TResult Function(RegisterResponseInvalidPool value)? invalidCognitoPool,
    required TResult orElse(),
  }) {
    if (userExists != null) {
      return userExists(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterResponseUserExistsToJson(
      this,
    );
  }
}

abstract class RegisterResponseUserExists implements RegisterResponse, Failure {
  const factory RegisterResponseUserExists({final String message}) =
      _$RegisterResponseUserExists;

  factory RegisterResponseUserExists.fromJson(Map<String, dynamic> json) =
      _$RegisterResponseUserExists.fromJson;

  String get message;
  @JsonKey(ignore: true)
  _$$RegisterResponseUserExistsCopyWith<_$RegisterResponseUserExists>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RegisterResponseInvalidEmailCopyWith<$Res> {
  factory _$$RegisterResponseInvalidEmailCopyWith(
          _$RegisterResponseInvalidEmail value,
          $Res Function(_$RegisterResponseInvalidEmail) then) =
      __$$RegisterResponseInvalidEmailCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$RegisterResponseInvalidEmailCopyWithImpl<$Res>
    extends _$RegisterResponseCopyWithImpl<$Res, _$RegisterResponseInvalidEmail>
    implements _$$RegisterResponseInvalidEmailCopyWith<$Res> {
  __$$RegisterResponseInvalidEmailCopyWithImpl(
      _$RegisterResponseInvalidEmail _value,
      $Res Function(_$RegisterResponseInvalidEmail) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$RegisterResponseInvalidEmail(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterResponseInvalidEmail
    with DiagnosticableTreeMixin
    implements RegisterResponseInvalidEmail {
  const _$RegisterResponseInvalidEmail(
      {required this.message, final String? $type})
      : $type = $type ?? 'invalidEmail';

  factory _$RegisterResponseInvalidEmail.fromJson(Map<String, dynamic> json) =>
      _$$RegisterResponseInvalidEmailFromJson(json);

  @override
  final String message;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RegisterResponse.invalidEmail(message: $message)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RegisterResponse.invalidEmail'))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterResponseInvalidEmail &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterResponseInvalidEmailCopyWith<_$RegisterResponseInvalidEmail>
      get copyWith => __$$RegisterResponseInvalidEmailCopyWithImpl<
          _$RegisterResponseInvalidEmail>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String userCognitoId) success,
    required TResult Function(String message) invalidPassword,
    required TResult Function(String message) userExists,
    required TResult Function(String message) invalidEmail,
    required TResult Function(String message) invalidCognitoPool,
  }) {
    return invalidEmail(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String userCognitoId)? success,
    TResult? Function(String message)? invalidPassword,
    TResult? Function(String message)? userExists,
    TResult? Function(String message)? invalidEmail,
    TResult? Function(String message)? invalidCognitoPool,
  }) {
    return invalidEmail?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String userCognitoId)? success,
    TResult Function(String message)? invalidPassword,
    TResult Function(String message)? userExists,
    TResult Function(String message)? invalidEmail,
    TResult Function(String message)? invalidCognitoPool,
    required TResult orElse(),
  }) {
    if (invalidEmail != null) {
      return invalidEmail(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RegisterResponseSuccess value) success,
    required TResult Function(RegisterResponseInvalidPassword value)
        invalidPassword,
    required TResult Function(RegisterResponseUserExists value) userExists,
    required TResult Function(RegisterResponseInvalidEmail value) invalidEmail,
    required TResult Function(RegisterResponseInvalidPool value)
        invalidCognitoPool,
  }) {
    return invalidEmail(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RegisterResponseSuccess value)? success,
    TResult? Function(RegisterResponseInvalidPassword value)? invalidPassword,
    TResult? Function(RegisterResponseUserExists value)? userExists,
    TResult? Function(RegisterResponseInvalidEmail value)? invalidEmail,
    TResult? Function(RegisterResponseInvalidPool value)? invalidCognitoPool,
  }) {
    return invalidEmail?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RegisterResponseSuccess value)? success,
    TResult Function(RegisterResponseInvalidPassword value)? invalidPassword,
    TResult Function(RegisterResponseUserExists value)? userExists,
    TResult Function(RegisterResponseInvalidEmail value)? invalidEmail,
    TResult Function(RegisterResponseInvalidPool value)? invalidCognitoPool,
    required TResult orElse(),
  }) {
    if (invalidEmail != null) {
      return invalidEmail(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterResponseInvalidEmailToJson(
      this,
    );
  }
}

abstract class RegisterResponseInvalidEmail
    implements RegisterResponse, Failure {
  const factory RegisterResponseInvalidEmail({required final String message}) =
      _$RegisterResponseInvalidEmail;

  factory RegisterResponseInvalidEmail.fromJson(Map<String, dynamic> json) =
      _$RegisterResponseInvalidEmail.fromJson;

  String get message;
  @JsonKey(ignore: true)
  _$$RegisterResponseInvalidEmailCopyWith<_$RegisterResponseInvalidEmail>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RegisterResponseInvalidPoolCopyWith<$Res> {
  factory _$$RegisterResponseInvalidPoolCopyWith(
          _$RegisterResponseInvalidPool value,
          $Res Function(_$RegisterResponseInvalidPool) then) =
      __$$RegisterResponseInvalidPoolCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$RegisterResponseInvalidPoolCopyWithImpl<$Res>
    extends _$RegisterResponseCopyWithImpl<$Res, _$RegisterResponseInvalidPool>
    implements _$$RegisterResponseInvalidPoolCopyWith<$Res> {
  __$$RegisterResponseInvalidPoolCopyWithImpl(
      _$RegisterResponseInvalidPool _value,
      $Res Function(_$RegisterResponseInvalidPool) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$RegisterResponseInvalidPool(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterResponseInvalidPool
    with DiagnosticableTreeMixin
    implements RegisterResponseInvalidPool {
  const _$RegisterResponseInvalidPool(
      {this.message = "Invalid cognito credentials", final String? $type})
      : $type = $type ?? 'invalidCognitoPool';

  factory _$RegisterResponseInvalidPool.fromJson(Map<String, dynamic> json) =>
      _$$RegisterResponseInvalidPoolFromJson(json);

  @override
  @JsonKey()
  final String message;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RegisterResponse.invalidCognitoPool(message: $message)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RegisterResponse.invalidCognitoPool'))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterResponseInvalidPool &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterResponseInvalidPoolCopyWith<_$RegisterResponseInvalidPool>
      get copyWith => __$$RegisterResponseInvalidPoolCopyWithImpl<
          _$RegisterResponseInvalidPool>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String userCognitoId) success,
    required TResult Function(String message) invalidPassword,
    required TResult Function(String message) userExists,
    required TResult Function(String message) invalidEmail,
    required TResult Function(String message) invalidCognitoPool,
  }) {
    return invalidCognitoPool(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String userCognitoId)? success,
    TResult? Function(String message)? invalidPassword,
    TResult? Function(String message)? userExists,
    TResult? Function(String message)? invalidEmail,
    TResult? Function(String message)? invalidCognitoPool,
  }) {
    return invalidCognitoPool?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String userCognitoId)? success,
    TResult Function(String message)? invalidPassword,
    TResult Function(String message)? userExists,
    TResult Function(String message)? invalidEmail,
    TResult Function(String message)? invalidCognitoPool,
    required TResult orElse(),
  }) {
    if (invalidCognitoPool != null) {
      return invalidCognitoPool(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RegisterResponseSuccess value) success,
    required TResult Function(RegisterResponseInvalidPassword value)
        invalidPassword,
    required TResult Function(RegisterResponseUserExists value) userExists,
    required TResult Function(RegisterResponseInvalidEmail value) invalidEmail,
    required TResult Function(RegisterResponseInvalidPool value)
        invalidCognitoPool,
  }) {
    return invalidCognitoPool(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RegisterResponseSuccess value)? success,
    TResult? Function(RegisterResponseInvalidPassword value)? invalidPassword,
    TResult? Function(RegisterResponseUserExists value)? userExists,
    TResult? Function(RegisterResponseInvalidEmail value)? invalidEmail,
    TResult? Function(RegisterResponseInvalidPool value)? invalidCognitoPool,
  }) {
    return invalidCognitoPool?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RegisterResponseSuccess value)? success,
    TResult Function(RegisterResponseInvalidPassword value)? invalidPassword,
    TResult Function(RegisterResponseUserExists value)? userExists,
    TResult Function(RegisterResponseInvalidEmail value)? invalidEmail,
    TResult Function(RegisterResponseInvalidPool value)? invalidCognitoPool,
    required TResult orElse(),
  }) {
    if (invalidCognitoPool != null) {
      return invalidCognitoPool(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterResponseInvalidPoolToJson(
      this,
    );
  }
}

abstract class RegisterResponseInvalidPool
    implements RegisterResponse, Failure {
  const factory RegisterResponseInvalidPool({final String message}) =
      _$RegisterResponseInvalidPool;

  factory RegisterResponseInvalidPool.fromJson(Map<String, dynamic> json) =
      _$RegisterResponseInvalidPool.fromJson;

  String get message;
  @JsonKey(ignore: true)
  _$$RegisterResponseInvalidPoolCopyWith<_$RegisterResponseInvalidPool>
      get copyWith => throw _privateConstructorUsedError;
}
