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

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'success':
      return LoginResponseSuccess.fromJson(json);
    case 'invalidLogin':
      return LoginResponseInvalidLogin.fromJson(json);
    case 'confirmationRequired':
      return LoginResponseConfirmationRequired.fromJson(json);
    case 'userNotFound':
      return LoginResponseUserNotFound.fromJson(json);
    case 'invalidCognitoPool':
      return LoginResponseInvalidPool.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'LoginResponse',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$LoginResponse {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String accessToken,
            String idToken,
            String refreshToken,
            int accessTokenExpiresAt,
            int idTokenExpiresAt,
            int? clockDrift,
            bool invalidated)
        success,
    required TResult Function(String message) invalidLogin,
    required TResult Function() confirmationRequired,
    required TResult Function(String message) userNotFound,
    required TResult Function(String message) invalidCognitoPool,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String accessToken,
            String idToken,
            String refreshToken,
            int accessTokenExpiresAt,
            int idTokenExpiresAt,
            int? clockDrift,
            bool invalidated)?
        success,
    TResult? Function(String message)? invalidLogin,
    TResult? Function()? confirmationRequired,
    TResult? Function(String message)? userNotFound,
    TResult? Function(String message)? invalidCognitoPool,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String accessToken,
            String idToken,
            String refreshToken,
            int accessTokenExpiresAt,
            int idTokenExpiresAt,
            int? clockDrift,
            bool invalidated)?
        success,
    TResult Function(String message)? invalidLogin,
    TResult Function()? confirmationRequired,
    TResult Function(String message)? userNotFound,
    TResult Function(String message)? invalidCognitoPool,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginResponseSuccess value) success,
    required TResult Function(LoginResponseInvalidLogin value) invalidLogin,
    required TResult Function(LoginResponseConfirmationRequired value)
        confirmationRequired,
    required TResult Function(LoginResponseUserNotFound value) userNotFound,
    required TResult Function(LoginResponseInvalidPool value)
        invalidCognitoPool,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginResponseSuccess value)? success,
    TResult? Function(LoginResponseInvalidLogin value)? invalidLogin,
    TResult? Function(LoginResponseConfirmationRequired value)?
        confirmationRequired,
    TResult? Function(LoginResponseUserNotFound value)? userNotFound,
    TResult? Function(LoginResponseInvalidPool value)? invalidCognitoPool,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginResponseSuccess value)? success,
    TResult Function(LoginResponseInvalidLogin value)? invalidLogin,
    TResult Function(LoginResponseConfirmationRequired value)?
        confirmationRequired,
    TResult Function(LoginResponseUserNotFound value)? userNotFound,
    TResult Function(LoginResponseInvalidPool value)? invalidCognitoPool,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginResponseCopyWith<$Res> {
  factory $LoginResponseCopyWith(
          LoginResponse value, $Res Function(LoginResponse) then) =
      _$LoginResponseCopyWithImpl<$Res, LoginResponse>;
}

/// @nodoc
class _$LoginResponseCopyWithImpl<$Res, $Val extends LoginResponse>
    implements $LoginResponseCopyWith<$Res> {
  _$LoginResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LoginResponseSuccessCopyWith<$Res> {
  factory _$$LoginResponseSuccessCopyWith(_$LoginResponseSuccess value,
          $Res Function(_$LoginResponseSuccess) then) =
      __$$LoginResponseSuccessCopyWithImpl<$Res>;
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
class __$$LoginResponseSuccessCopyWithImpl<$Res>
    extends _$LoginResponseCopyWithImpl<$Res, _$LoginResponseSuccess>
    implements _$$LoginResponseSuccessCopyWith<$Res> {
  __$$LoginResponseSuccessCopyWithImpl(_$LoginResponseSuccess _value,
      $Res Function(_$LoginResponseSuccess) _then)
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
    return _then(_$LoginResponseSuccess(
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
class _$LoginResponseSuccess
    with DiagnosticableTreeMixin, IAuthCredentialsEntity
    implements LoginResponseSuccess {
  const _$LoginResponseSuccess(
      {required this.accessToken,
      required this.idToken,
      required this.refreshToken,
      required this.accessTokenExpiresAt,
      required this.idTokenExpiresAt,
      required this.clockDrift,
      this.invalidated = false,
      final String? $type})
      : $type = $type ?? 'success';

  factory _$LoginResponseSuccess.fromJson(Map<String, dynamic> json) =>
      _$$LoginResponseSuccessFromJson(json);

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

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LoginResponse.success(accessToken: $accessToken, idToken: $idToken, refreshToken: $refreshToken, accessTokenExpiresAt: $accessTokenExpiresAt, idTokenExpiresAt: $idTokenExpiresAt, clockDrift: $clockDrift, invalidated: $invalidated)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LoginResponse.success'))
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
            other is _$LoginResponseSuccess &&
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
  _$$LoginResponseSuccessCopyWith<_$LoginResponseSuccess> get copyWith =>
      __$$LoginResponseSuccessCopyWithImpl<_$LoginResponseSuccess>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String accessToken,
            String idToken,
            String refreshToken,
            int accessTokenExpiresAt,
            int idTokenExpiresAt,
            int? clockDrift,
            bool invalidated)
        success,
    required TResult Function(String message) invalidLogin,
    required TResult Function() confirmationRequired,
    required TResult Function(String message) userNotFound,
    required TResult Function(String message) invalidCognitoPool,
  }) {
    return success(accessToken, idToken, refreshToken, accessTokenExpiresAt,
        idTokenExpiresAt, clockDrift, invalidated);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String accessToken,
            String idToken,
            String refreshToken,
            int accessTokenExpiresAt,
            int idTokenExpiresAt,
            int? clockDrift,
            bool invalidated)?
        success,
    TResult? Function(String message)? invalidLogin,
    TResult? Function()? confirmationRequired,
    TResult? Function(String message)? userNotFound,
    TResult? Function(String message)? invalidCognitoPool,
  }) {
    return success?.call(accessToken, idToken, refreshToken,
        accessTokenExpiresAt, idTokenExpiresAt, clockDrift, invalidated);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String accessToken,
            String idToken,
            String refreshToken,
            int accessTokenExpiresAt,
            int idTokenExpiresAt,
            int? clockDrift,
            bool invalidated)?
        success,
    TResult Function(String message)? invalidLogin,
    TResult Function()? confirmationRequired,
    TResult Function(String message)? userNotFound,
    TResult Function(String message)? invalidCognitoPool,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(accessToken, idToken, refreshToken, accessTokenExpiresAt,
          idTokenExpiresAt, clockDrift, invalidated);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginResponseSuccess value) success,
    required TResult Function(LoginResponseInvalidLogin value) invalidLogin,
    required TResult Function(LoginResponseConfirmationRequired value)
        confirmationRequired,
    required TResult Function(LoginResponseUserNotFound value) userNotFound,
    required TResult Function(LoginResponseInvalidPool value)
        invalidCognitoPool,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginResponseSuccess value)? success,
    TResult? Function(LoginResponseInvalidLogin value)? invalidLogin,
    TResult? Function(LoginResponseConfirmationRequired value)?
        confirmationRequired,
    TResult? Function(LoginResponseUserNotFound value)? userNotFound,
    TResult? Function(LoginResponseInvalidPool value)? invalidCognitoPool,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginResponseSuccess value)? success,
    TResult Function(LoginResponseInvalidLogin value)? invalidLogin,
    TResult Function(LoginResponseConfirmationRequired value)?
        confirmationRequired,
    TResult Function(LoginResponseUserNotFound value)? userNotFound,
    TResult Function(LoginResponseInvalidPool value)? invalidCognitoPool,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginResponseSuccessToJson(
      this,
    );
  }
}

abstract class LoginResponseSuccess
    implements LoginResponse, IAuthCredentialsEntity {
  const factory LoginResponseSuccess(
      {required final String accessToken,
      required final String idToken,
      required final String refreshToken,
      required final int accessTokenExpiresAt,
      required final int idTokenExpiresAt,
      required final int? clockDrift,
      final bool invalidated}) = _$LoginResponseSuccess;

  factory LoginResponseSuccess.fromJson(Map<String, dynamic> json) =
      _$LoginResponseSuccess.fromJson;

  String get accessToken;
  String get idToken;
  String get refreshToken;
  int get accessTokenExpiresAt;
  int get idTokenExpiresAt;
  int? get clockDrift;
  bool get invalidated;
  @JsonKey(ignore: true)
  _$$LoginResponseSuccessCopyWith<_$LoginResponseSuccess> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoginResponseInvalidLoginCopyWith<$Res> {
  factory _$$LoginResponseInvalidLoginCopyWith(
          _$LoginResponseInvalidLogin value,
          $Res Function(_$LoginResponseInvalidLogin) then) =
      __$$LoginResponseInvalidLoginCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$LoginResponseInvalidLoginCopyWithImpl<$Res>
    extends _$LoginResponseCopyWithImpl<$Res, _$LoginResponseInvalidLogin>
    implements _$$LoginResponseInvalidLoginCopyWith<$Res> {
  __$$LoginResponseInvalidLoginCopyWithImpl(_$LoginResponseInvalidLogin _value,
      $Res Function(_$LoginResponseInvalidLogin) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$LoginResponseInvalidLogin(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginResponseInvalidLogin
    with DiagnosticableTreeMixin
    implements LoginResponseInvalidLogin {
  const _$LoginResponseInvalidLogin(
      {this.message = "Invalid email/password", final String? $type})
      : $type = $type ?? 'invalidLogin';

  factory _$LoginResponseInvalidLogin.fromJson(Map<String, dynamic> json) =>
      _$$LoginResponseInvalidLoginFromJson(json);

  @override
  @JsonKey()
  final String message;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LoginResponse.invalidLogin(message: $message)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LoginResponse.invalidLogin'))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginResponseInvalidLogin &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginResponseInvalidLoginCopyWith<_$LoginResponseInvalidLogin>
      get copyWith => __$$LoginResponseInvalidLoginCopyWithImpl<
          _$LoginResponseInvalidLogin>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String accessToken,
            String idToken,
            String refreshToken,
            int accessTokenExpiresAt,
            int idTokenExpiresAt,
            int? clockDrift,
            bool invalidated)
        success,
    required TResult Function(String message) invalidLogin,
    required TResult Function() confirmationRequired,
    required TResult Function(String message) userNotFound,
    required TResult Function(String message) invalidCognitoPool,
  }) {
    return invalidLogin(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String accessToken,
            String idToken,
            String refreshToken,
            int accessTokenExpiresAt,
            int idTokenExpiresAt,
            int? clockDrift,
            bool invalidated)?
        success,
    TResult? Function(String message)? invalidLogin,
    TResult? Function()? confirmationRequired,
    TResult? Function(String message)? userNotFound,
    TResult? Function(String message)? invalidCognitoPool,
  }) {
    return invalidLogin?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String accessToken,
            String idToken,
            String refreshToken,
            int accessTokenExpiresAt,
            int idTokenExpiresAt,
            int? clockDrift,
            bool invalidated)?
        success,
    TResult Function(String message)? invalidLogin,
    TResult Function()? confirmationRequired,
    TResult Function(String message)? userNotFound,
    TResult Function(String message)? invalidCognitoPool,
    required TResult orElse(),
  }) {
    if (invalidLogin != null) {
      return invalidLogin(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginResponseSuccess value) success,
    required TResult Function(LoginResponseInvalidLogin value) invalidLogin,
    required TResult Function(LoginResponseConfirmationRequired value)
        confirmationRequired,
    required TResult Function(LoginResponseUserNotFound value) userNotFound,
    required TResult Function(LoginResponseInvalidPool value)
        invalidCognitoPool,
  }) {
    return invalidLogin(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginResponseSuccess value)? success,
    TResult? Function(LoginResponseInvalidLogin value)? invalidLogin,
    TResult? Function(LoginResponseConfirmationRequired value)?
        confirmationRequired,
    TResult? Function(LoginResponseUserNotFound value)? userNotFound,
    TResult? Function(LoginResponseInvalidPool value)? invalidCognitoPool,
  }) {
    return invalidLogin?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginResponseSuccess value)? success,
    TResult Function(LoginResponseInvalidLogin value)? invalidLogin,
    TResult Function(LoginResponseConfirmationRequired value)?
        confirmationRequired,
    TResult Function(LoginResponseUserNotFound value)? userNotFound,
    TResult Function(LoginResponseInvalidPool value)? invalidCognitoPool,
    required TResult orElse(),
  }) {
    if (invalidLogin != null) {
      return invalidLogin(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginResponseInvalidLoginToJson(
      this,
    );
  }
}

abstract class LoginResponseInvalidLogin implements LoginResponse {
  const factory LoginResponseInvalidLogin({final String message}) =
      _$LoginResponseInvalidLogin;

  factory LoginResponseInvalidLogin.fromJson(Map<String, dynamic> json) =
      _$LoginResponseInvalidLogin.fromJson;

  String get message;
  @JsonKey(ignore: true)
  _$$LoginResponseInvalidLoginCopyWith<_$LoginResponseInvalidLogin>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoginResponseConfirmationRequiredCopyWith<$Res> {
  factory _$$LoginResponseConfirmationRequiredCopyWith(
          _$LoginResponseConfirmationRequired value,
          $Res Function(_$LoginResponseConfirmationRequired) then) =
      __$$LoginResponseConfirmationRequiredCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoginResponseConfirmationRequiredCopyWithImpl<$Res>
    extends _$LoginResponseCopyWithImpl<$Res,
        _$LoginResponseConfirmationRequired>
    implements _$$LoginResponseConfirmationRequiredCopyWith<$Res> {
  __$$LoginResponseConfirmationRequiredCopyWithImpl(
      _$LoginResponseConfirmationRequired _value,
      $Res Function(_$LoginResponseConfirmationRequired) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$LoginResponseConfirmationRequired
    with DiagnosticableTreeMixin
    implements LoginResponseConfirmationRequired {
  const _$LoginResponseConfirmationRequired({final String? $type})
      : $type = $type ?? 'confirmationRequired';

  factory _$LoginResponseConfirmationRequired.fromJson(
          Map<String, dynamic> json) =>
      _$$LoginResponseConfirmationRequiredFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LoginResponse.confirmationRequired()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty('type', 'LoginResponse.confirmationRequired'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginResponseConfirmationRequired);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String accessToken,
            String idToken,
            String refreshToken,
            int accessTokenExpiresAt,
            int idTokenExpiresAt,
            int? clockDrift,
            bool invalidated)
        success,
    required TResult Function(String message) invalidLogin,
    required TResult Function() confirmationRequired,
    required TResult Function(String message) userNotFound,
    required TResult Function(String message) invalidCognitoPool,
  }) {
    return confirmationRequired();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String accessToken,
            String idToken,
            String refreshToken,
            int accessTokenExpiresAt,
            int idTokenExpiresAt,
            int? clockDrift,
            bool invalidated)?
        success,
    TResult? Function(String message)? invalidLogin,
    TResult? Function()? confirmationRequired,
    TResult? Function(String message)? userNotFound,
    TResult? Function(String message)? invalidCognitoPool,
  }) {
    return confirmationRequired?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String accessToken,
            String idToken,
            String refreshToken,
            int accessTokenExpiresAt,
            int idTokenExpiresAt,
            int? clockDrift,
            bool invalidated)?
        success,
    TResult Function(String message)? invalidLogin,
    TResult Function()? confirmationRequired,
    TResult Function(String message)? userNotFound,
    TResult Function(String message)? invalidCognitoPool,
    required TResult orElse(),
  }) {
    if (confirmationRequired != null) {
      return confirmationRequired();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginResponseSuccess value) success,
    required TResult Function(LoginResponseInvalidLogin value) invalidLogin,
    required TResult Function(LoginResponseConfirmationRequired value)
        confirmationRequired,
    required TResult Function(LoginResponseUserNotFound value) userNotFound,
    required TResult Function(LoginResponseInvalidPool value)
        invalidCognitoPool,
  }) {
    return confirmationRequired(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginResponseSuccess value)? success,
    TResult? Function(LoginResponseInvalidLogin value)? invalidLogin,
    TResult? Function(LoginResponseConfirmationRequired value)?
        confirmationRequired,
    TResult? Function(LoginResponseUserNotFound value)? userNotFound,
    TResult? Function(LoginResponseInvalidPool value)? invalidCognitoPool,
  }) {
    return confirmationRequired?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginResponseSuccess value)? success,
    TResult Function(LoginResponseInvalidLogin value)? invalidLogin,
    TResult Function(LoginResponseConfirmationRequired value)?
        confirmationRequired,
    TResult Function(LoginResponseUserNotFound value)? userNotFound,
    TResult Function(LoginResponseInvalidPool value)? invalidCognitoPool,
    required TResult orElse(),
  }) {
    if (confirmationRequired != null) {
      return confirmationRequired(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginResponseConfirmationRequiredToJson(
      this,
    );
  }
}

abstract class LoginResponseConfirmationRequired implements LoginResponse {
  const factory LoginResponseConfirmationRequired() =
      _$LoginResponseConfirmationRequired;

  factory LoginResponseConfirmationRequired.fromJson(
      Map<String, dynamic> json) = _$LoginResponseConfirmationRequired.fromJson;
}

/// @nodoc
abstract class _$$LoginResponseUserNotFoundCopyWith<$Res> {
  factory _$$LoginResponseUserNotFoundCopyWith(
          _$LoginResponseUserNotFound value,
          $Res Function(_$LoginResponseUserNotFound) then) =
      __$$LoginResponseUserNotFoundCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$LoginResponseUserNotFoundCopyWithImpl<$Res>
    extends _$LoginResponseCopyWithImpl<$Res, _$LoginResponseUserNotFound>
    implements _$$LoginResponseUserNotFoundCopyWith<$Res> {
  __$$LoginResponseUserNotFoundCopyWithImpl(_$LoginResponseUserNotFound _value,
      $Res Function(_$LoginResponseUserNotFound) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$LoginResponseUserNotFound(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginResponseUserNotFound
    with DiagnosticableTreeMixin
    implements LoginResponseUserNotFound {
  const _$LoginResponseUserNotFound(
      {this.message = "No such user exists", final String? $type})
      : $type = $type ?? 'userNotFound';

  factory _$LoginResponseUserNotFound.fromJson(Map<String, dynamic> json) =>
      _$$LoginResponseUserNotFoundFromJson(json);

  @override
  @JsonKey()
  final String message;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LoginResponse.userNotFound(message: $message)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LoginResponse.userNotFound'))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginResponseUserNotFound &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginResponseUserNotFoundCopyWith<_$LoginResponseUserNotFound>
      get copyWith => __$$LoginResponseUserNotFoundCopyWithImpl<
          _$LoginResponseUserNotFound>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String accessToken,
            String idToken,
            String refreshToken,
            int accessTokenExpiresAt,
            int idTokenExpiresAt,
            int? clockDrift,
            bool invalidated)
        success,
    required TResult Function(String message) invalidLogin,
    required TResult Function() confirmationRequired,
    required TResult Function(String message) userNotFound,
    required TResult Function(String message) invalidCognitoPool,
  }) {
    return userNotFound(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String accessToken,
            String idToken,
            String refreshToken,
            int accessTokenExpiresAt,
            int idTokenExpiresAt,
            int? clockDrift,
            bool invalidated)?
        success,
    TResult? Function(String message)? invalidLogin,
    TResult? Function()? confirmationRequired,
    TResult? Function(String message)? userNotFound,
    TResult? Function(String message)? invalidCognitoPool,
  }) {
    return userNotFound?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String accessToken,
            String idToken,
            String refreshToken,
            int accessTokenExpiresAt,
            int idTokenExpiresAt,
            int? clockDrift,
            bool invalidated)?
        success,
    TResult Function(String message)? invalidLogin,
    TResult Function()? confirmationRequired,
    TResult Function(String message)? userNotFound,
    TResult Function(String message)? invalidCognitoPool,
    required TResult orElse(),
  }) {
    if (userNotFound != null) {
      return userNotFound(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginResponseSuccess value) success,
    required TResult Function(LoginResponseInvalidLogin value) invalidLogin,
    required TResult Function(LoginResponseConfirmationRequired value)
        confirmationRequired,
    required TResult Function(LoginResponseUserNotFound value) userNotFound,
    required TResult Function(LoginResponseInvalidPool value)
        invalidCognitoPool,
  }) {
    return userNotFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginResponseSuccess value)? success,
    TResult? Function(LoginResponseInvalidLogin value)? invalidLogin,
    TResult? Function(LoginResponseConfirmationRequired value)?
        confirmationRequired,
    TResult? Function(LoginResponseUserNotFound value)? userNotFound,
    TResult? Function(LoginResponseInvalidPool value)? invalidCognitoPool,
  }) {
    return userNotFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginResponseSuccess value)? success,
    TResult Function(LoginResponseInvalidLogin value)? invalidLogin,
    TResult Function(LoginResponseConfirmationRequired value)?
        confirmationRequired,
    TResult Function(LoginResponseUserNotFound value)? userNotFound,
    TResult Function(LoginResponseInvalidPool value)? invalidCognitoPool,
    required TResult orElse(),
  }) {
    if (userNotFound != null) {
      return userNotFound(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginResponseUserNotFoundToJson(
      this,
    );
  }
}

abstract class LoginResponseUserNotFound implements LoginResponse, Failure {
  const factory LoginResponseUserNotFound({final String message}) =
      _$LoginResponseUserNotFound;

  factory LoginResponseUserNotFound.fromJson(Map<String, dynamic> json) =
      _$LoginResponseUserNotFound.fromJson;

  String get message;
  @JsonKey(ignore: true)
  _$$LoginResponseUserNotFoundCopyWith<_$LoginResponseUserNotFound>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoginResponseInvalidPoolCopyWith<$Res> {
  factory _$$LoginResponseInvalidPoolCopyWith(_$LoginResponseInvalidPool value,
          $Res Function(_$LoginResponseInvalidPool) then) =
      __$$LoginResponseInvalidPoolCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$LoginResponseInvalidPoolCopyWithImpl<$Res>
    extends _$LoginResponseCopyWithImpl<$Res, _$LoginResponseInvalidPool>
    implements _$$LoginResponseInvalidPoolCopyWith<$Res> {
  __$$LoginResponseInvalidPoolCopyWithImpl(_$LoginResponseInvalidPool _value,
      $Res Function(_$LoginResponseInvalidPool) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$LoginResponseInvalidPool(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginResponseInvalidPool
    with DiagnosticableTreeMixin
    implements LoginResponseInvalidPool {
  const _$LoginResponseInvalidPool(
      {this.message = "Invalid cognito credentials", final String? $type})
      : $type = $type ?? 'invalidCognitoPool';

  factory _$LoginResponseInvalidPool.fromJson(Map<String, dynamic> json) =>
      _$$LoginResponseInvalidPoolFromJson(json);

  @override
  @JsonKey()
  final String message;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LoginResponse.invalidCognitoPool(message: $message)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LoginResponse.invalidCognitoPool'))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginResponseInvalidPool &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginResponseInvalidPoolCopyWith<_$LoginResponseInvalidPool>
      get copyWith =>
          __$$LoginResponseInvalidPoolCopyWithImpl<_$LoginResponseInvalidPool>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String accessToken,
            String idToken,
            String refreshToken,
            int accessTokenExpiresAt,
            int idTokenExpiresAt,
            int? clockDrift,
            bool invalidated)
        success,
    required TResult Function(String message) invalidLogin,
    required TResult Function() confirmationRequired,
    required TResult Function(String message) userNotFound,
    required TResult Function(String message) invalidCognitoPool,
  }) {
    return invalidCognitoPool(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String accessToken,
            String idToken,
            String refreshToken,
            int accessTokenExpiresAt,
            int idTokenExpiresAt,
            int? clockDrift,
            bool invalidated)?
        success,
    TResult? Function(String message)? invalidLogin,
    TResult? Function()? confirmationRequired,
    TResult? Function(String message)? userNotFound,
    TResult? Function(String message)? invalidCognitoPool,
  }) {
    return invalidCognitoPool?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String accessToken,
            String idToken,
            String refreshToken,
            int accessTokenExpiresAt,
            int idTokenExpiresAt,
            int? clockDrift,
            bool invalidated)?
        success,
    TResult Function(String message)? invalidLogin,
    TResult Function()? confirmationRequired,
    TResult Function(String message)? userNotFound,
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
    required TResult Function(LoginResponseSuccess value) success,
    required TResult Function(LoginResponseInvalidLogin value) invalidLogin,
    required TResult Function(LoginResponseConfirmationRequired value)
        confirmationRequired,
    required TResult Function(LoginResponseUserNotFound value) userNotFound,
    required TResult Function(LoginResponseInvalidPool value)
        invalidCognitoPool,
  }) {
    return invalidCognitoPool(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginResponseSuccess value)? success,
    TResult? Function(LoginResponseInvalidLogin value)? invalidLogin,
    TResult? Function(LoginResponseConfirmationRequired value)?
        confirmationRequired,
    TResult? Function(LoginResponseUserNotFound value)? userNotFound,
    TResult? Function(LoginResponseInvalidPool value)? invalidCognitoPool,
  }) {
    return invalidCognitoPool?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginResponseSuccess value)? success,
    TResult Function(LoginResponseInvalidLogin value)? invalidLogin,
    TResult Function(LoginResponseConfirmationRequired value)?
        confirmationRequired,
    TResult Function(LoginResponseUserNotFound value)? userNotFound,
    TResult Function(LoginResponseInvalidPool value)? invalidCognitoPool,
    required TResult orElse(),
  }) {
    if (invalidCognitoPool != null) {
      return invalidCognitoPool(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginResponseInvalidPoolToJson(
      this,
    );
  }
}

abstract class LoginResponseInvalidPool implements LoginResponse, Failure {
  const factory LoginResponseInvalidPool({final String message}) =
      _$LoginResponseInvalidPool;

  factory LoginResponseInvalidPool.fromJson(Map<String, dynamic> json) =
      _$LoginResponseInvalidPool.fromJson;

  String get message;
  @JsonKey(ignore: true)
  _$$LoginResponseInvalidPoolCopyWith<_$LoginResponseInvalidPool>
      get copyWith => throw _privateConstructorUsedError;
}
