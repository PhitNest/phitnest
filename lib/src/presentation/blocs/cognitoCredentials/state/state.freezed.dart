// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CognitoCredentialsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(CognitoCredentialsEntity credentials) loaded,
    required TResult Function(
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)
        loading,
    required TResult Function(
            CognitoCredentialsEntity credentials,
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)
        reloading,
    required TResult Function() initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(CognitoCredentialsEntity credentials)? loaded,
    TResult? Function(
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)?
        loading,
    TResult? Function(
            CognitoCredentialsEntity credentials,
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)?
        reloading,
    TResult? Function()? initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(CognitoCredentialsEntity credentials)? loaded,
    TResult Function(
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)?
        loading,
    TResult Function(
            CognitoCredentialsEntity credentials,
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)?
        reloading,
    TResult Function()? initial,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CognitoCredentialsLoadedState value) loaded,
    required TResult Function(CognitoCredentialsLoadingState value) loading,
    required TResult Function(CognitoCredentialsReloadingState value) reloading,
    required TResult Function(CognitoCredentialsInitialState value) initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CognitoCredentialsLoadedState value)? loaded,
    TResult? Function(CognitoCredentialsLoadingState value)? loading,
    TResult? Function(CognitoCredentialsReloadingState value)? reloading,
    TResult? Function(CognitoCredentialsInitialState value)? initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CognitoCredentialsLoadedState value)? loaded,
    TResult Function(CognitoCredentialsLoadingState value)? loading,
    TResult Function(CognitoCredentialsReloadingState value)? reloading,
    TResult Function(CognitoCredentialsInitialState value)? initial,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CognitoCredentialsStateCopyWith<$Res> {
  factory $CognitoCredentialsStateCopyWith(CognitoCredentialsState value,
          $Res Function(CognitoCredentialsState) then) =
      _$CognitoCredentialsStateCopyWithImpl<$Res, CognitoCredentialsState>;
}

/// @nodoc
class _$CognitoCredentialsStateCopyWithImpl<$Res,
        $Val extends CognitoCredentialsState>
    implements $CognitoCredentialsStateCopyWith<$Res> {
  _$CognitoCredentialsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$CognitoCredentialsLoadedStateCopyWith<$Res> {
  factory _$$CognitoCredentialsLoadedStateCopyWith(
          _$CognitoCredentialsLoadedState value,
          $Res Function(_$CognitoCredentialsLoadedState) then) =
      __$$CognitoCredentialsLoadedStateCopyWithImpl<$Res>;
  @useResult
  $Res call({CognitoCredentialsEntity credentials});

  $CognitoCredentialsEntityCopyWith<$Res> get credentials;
}

/// @nodoc
class __$$CognitoCredentialsLoadedStateCopyWithImpl<$Res>
    extends _$CognitoCredentialsStateCopyWithImpl<$Res,
        _$CognitoCredentialsLoadedState>
    implements _$$CognitoCredentialsLoadedStateCopyWith<$Res> {
  __$$CognitoCredentialsLoadedStateCopyWithImpl(
      _$CognitoCredentialsLoadedState _value,
      $Res Function(_$CognitoCredentialsLoadedState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? credentials = null,
  }) {
    return _then(_$CognitoCredentialsLoadedState(
      credentials: null == credentials
          ? _value.credentials
          : credentials // ignore: cast_nullable_to_non_nullable
              as CognitoCredentialsEntity,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $CognitoCredentialsEntityCopyWith<$Res> get credentials {
    return $CognitoCredentialsEntityCopyWith<$Res>(_value.credentials, (value) {
      return _then(_value.copyWith(credentials: value));
    });
  }
}

/// @nodoc

class _$CognitoCredentialsLoadedState
    with DiagnosticableTreeMixin
    implements CognitoCredentialsLoadedState {
  const _$CognitoCredentialsLoadedState({required this.credentials});

  @override
  final CognitoCredentialsEntity credentials;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CognitoCredentialsState.loaded(credentials: $credentials)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CognitoCredentialsState.loaded'))
      ..add(DiagnosticsProperty('credentials', credentials));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CognitoCredentialsLoadedState &&
            (identical(other.credentials, credentials) ||
                other.credentials == credentials));
  }

  @override
  int get hashCode => Object.hash(runtimeType, credentials);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CognitoCredentialsLoadedStateCopyWith<_$CognitoCredentialsLoadedState>
      get copyWith => __$$CognitoCredentialsLoadedStateCopyWithImpl<
          _$CognitoCredentialsLoadedState>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(CognitoCredentialsEntity credentials) loaded,
    required TResult Function(
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)
        loading,
    required TResult Function(
            CognitoCredentialsEntity credentials,
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)
        reloading,
    required TResult Function() initial,
  }) {
    return loaded(credentials);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(CognitoCredentialsEntity credentials)? loaded,
    TResult? Function(
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)?
        loading,
    TResult? Function(
            CognitoCredentialsEntity credentials,
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)?
        reloading,
    TResult? Function()? initial,
  }) {
    return loaded?.call(credentials);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(CognitoCredentialsEntity credentials)? loaded,
    TResult Function(
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)?
        loading,
    TResult Function(
            CognitoCredentialsEntity credentials,
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)?
        reloading,
    TResult Function()? initial,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(credentials);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CognitoCredentialsLoadedState value) loaded,
    required TResult Function(CognitoCredentialsLoadingState value) loading,
    required TResult Function(CognitoCredentialsReloadingState value) reloading,
    required TResult Function(CognitoCredentialsInitialState value) initial,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CognitoCredentialsLoadedState value)? loaded,
    TResult? Function(CognitoCredentialsLoadingState value)? loading,
    TResult? Function(CognitoCredentialsReloadingState value)? reloading,
    TResult? Function(CognitoCredentialsInitialState value)? initial,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CognitoCredentialsLoadedState value)? loaded,
    TResult Function(CognitoCredentialsLoadingState value)? loading,
    TResult Function(CognitoCredentialsReloadingState value)? reloading,
    TResult Function(CognitoCredentialsInitialState value)? initial,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class CognitoCredentialsLoadedState
    implements CognitoCredentialsState {
  const factory CognitoCredentialsLoadedState(
          {required final CognitoCredentialsEntity credentials}) =
      _$CognitoCredentialsLoadedState;

  CognitoCredentialsEntity get credentials;
  @JsonKey(ignore: true)
  _$$CognitoCredentialsLoadedStateCopyWith<_$CognitoCredentialsLoadedState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CognitoCredentialsLoadingStateCopyWith<$Res> {
  factory _$$CognitoCredentialsLoadingStateCopyWith(
          _$CognitoCredentialsLoadingState value,
          $Res Function(_$CognitoCredentialsLoadingState) then) =
      __$$CognitoCredentialsLoadingStateCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {CancelableOperation<
              Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
          operation});
}

/// @nodoc
class __$$CognitoCredentialsLoadingStateCopyWithImpl<$Res>
    extends _$CognitoCredentialsStateCopyWithImpl<$Res,
        _$CognitoCredentialsLoadingState>
    implements _$$CognitoCredentialsLoadingStateCopyWith<$Res> {
  __$$CognitoCredentialsLoadingStateCopyWithImpl(
      _$CognitoCredentialsLoadingState _value,
      $Res Function(_$CognitoCredentialsLoadingState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? operation = null,
  }) {
    return _then(_$CognitoCredentialsLoadingState(
      operation: null == operation
          ? _value.operation
          : operation // ignore: cast_nullable_to_non_nullable
              as CancelableOperation<
                  Either<CognitoCredentialsEntity, NetworkConnectionFailure>>,
    ));
  }
}

/// @nodoc

class _$CognitoCredentialsLoadingState
    with DiagnosticableTreeMixin
    implements CognitoCredentialsLoadingState {
  const _$CognitoCredentialsLoadingState({required this.operation});

  @override
  final CancelableOperation<
      Either<CognitoCredentialsEntity, NetworkConnectionFailure>> operation;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CognitoCredentialsState.loading(operation: $operation)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CognitoCredentialsState.loading'))
      ..add(DiagnosticsProperty('operation', operation));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CognitoCredentialsLoadingState &&
            (identical(other.operation, operation) ||
                other.operation == operation));
  }

  @override
  int get hashCode => Object.hash(runtimeType, operation);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CognitoCredentialsLoadingStateCopyWith<_$CognitoCredentialsLoadingState>
      get copyWith => __$$CognitoCredentialsLoadingStateCopyWithImpl<
          _$CognitoCredentialsLoadingState>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(CognitoCredentialsEntity credentials) loaded,
    required TResult Function(
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)
        loading,
    required TResult Function(
            CognitoCredentialsEntity credentials,
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)
        reloading,
    required TResult Function() initial,
  }) {
    return loading(operation);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(CognitoCredentialsEntity credentials)? loaded,
    TResult? Function(
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)?
        loading,
    TResult? Function(
            CognitoCredentialsEntity credentials,
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)?
        reloading,
    TResult? Function()? initial,
  }) {
    return loading?.call(operation);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(CognitoCredentialsEntity credentials)? loaded,
    TResult Function(
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)?
        loading,
    TResult Function(
            CognitoCredentialsEntity credentials,
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)?
        reloading,
    TResult Function()? initial,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(operation);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CognitoCredentialsLoadedState value) loaded,
    required TResult Function(CognitoCredentialsLoadingState value) loading,
    required TResult Function(CognitoCredentialsReloadingState value) reloading,
    required TResult Function(CognitoCredentialsInitialState value) initial,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CognitoCredentialsLoadedState value)? loaded,
    TResult? Function(CognitoCredentialsLoadingState value)? loading,
    TResult? Function(CognitoCredentialsReloadingState value)? reloading,
    TResult? Function(CognitoCredentialsInitialState value)? initial,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CognitoCredentialsLoadedState value)? loaded,
    TResult Function(CognitoCredentialsLoadingState value)? loading,
    TResult Function(CognitoCredentialsReloadingState value)? reloading,
    TResult Function(CognitoCredentialsInitialState value)? initial,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class CognitoCredentialsLoadingState
    implements CognitoCredentialsState {
  const factory CognitoCredentialsLoadingState(
      {required final CancelableOperation<
              Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
          operation}) = _$CognitoCredentialsLoadingState;

  CancelableOperation<
      Either<CognitoCredentialsEntity, NetworkConnectionFailure>> get operation;
  @JsonKey(ignore: true)
  _$$CognitoCredentialsLoadingStateCopyWith<_$CognitoCredentialsLoadingState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CognitoCredentialsReloadingStateCopyWith<$Res> {
  factory _$$CognitoCredentialsReloadingStateCopyWith(
          _$CognitoCredentialsReloadingState value,
          $Res Function(_$CognitoCredentialsReloadingState) then) =
      __$$CognitoCredentialsReloadingStateCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {CognitoCredentialsEntity credentials,
      CancelableOperation<
              Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
          operation});

  $CognitoCredentialsEntityCopyWith<$Res> get credentials;
}

/// @nodoc
class __$$CognitoCredentialsReloadingStateCopyWithImpl<$Res>
    extends _$CognitoCredentialsStateCopyWithImpl<$Res,
        _$CognitoCredentialsReloadingState>
    implements _$$CognitoCredentialsReloadingStateCopyWith<$Res> {
  __$$CognitoCredentialsReloadingStateCopyWithImpl(
      _$CognitoCredentialsReloadingState _value,
      $Res Function(_$CognitoCredentialsReloadingState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? credentials = null,
    Object? operation = null,
  }) {
    return _then(_$CognitoCredentialsReloadingState(
      credentials: null == credentials
          ? _value.credentials
          : credentials // ignore: cast_nullable_to_non_nullable
              as CognitoCredentialsEntity,
      operation: null == operation
          ? _value.operation
          : operation // ignore: cast_nullable_to_non_nullable
              as CancelableOperation<
                  Either<CognitoCredentialsEntity, NetworkConnectionFailure>>,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $CognitoCredentialsEntityCopyWith<$Res> get credentials {
    return $CognitoCredentialsEntityCopyWith<$Res>(_value.credentials, (value) {
      return _then(_value.copyWith(credentials: value));
    });
  }
}

/// @nodoc

class _$CognitoCredentialsReloadingState
    with DiagnosticableTreeMixin
    implements CognitoCredentialsReloadingState {
  const _$CognitoCredentialsReloadingState(
      {required this.credentials, required this.operation});

  @override
  final CognitoCredentialsEntity credentials;
  @override
  final CancelableOperation<
      Either<CognitoCredentialsEntity, NetworkConnectionFailure>> operation;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CognitoCredentialsState.reloading(credentials: $credentials, operation: $operation)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CognitoCredentialsState.reloading'))
      ..add(DiagnosticsProperty('credentials', credentials))
      ..add(DiagnosticsProperty('operation', operation));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CognitoCredentialsReloadingState &&
            (identical(other.credentials, credentials) ||
                other.credentials == credentials) &&
            (identical(other.operation, operation) ||
                other.operation == operation));
  }

  @override
  int get hashCode => Object.hash(runtimeType, credentials, operation);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CognitoCredentialsReloadingStateCopyWith<
          _$CognitoCredentialsReloadingState>
      get copyWith => __$$CognitoCredentialsReloadingStateCopyWithImpl<
          _$CognitoCredentialsReloadingState>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(CognitoCredentialsEntity credentials) loaded,
    required TResult Function(
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)
        loading,
    required TResult Function(
            CognitoCredentialsEntity credentials,
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)
        reloading,
    required TResult Function() initial,
  }) {
    return reloading(credentials, operation);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(CognitoCredentialsEntity credentials)? loaded,
    TResult? Function(
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)?
        loading,
    TResult? Function(
            CognitoCredentialsEntity credentials,
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)?
        reloading,
    TResult? Function()? initial,
  }) {
    return reloading?.call(credentials, operation);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(CognitoCredentialsEntity credentials)? loaded,
    TResult Function(
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)?
        loading,
    TResult Function(
            CognitoCredentialsEntity credentials,
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)?
        reloading,
    TResult Function()? initial,
    required TResult orElse(),
  }) {
    if (reloading != null) {
      return reloading(credentials, operation);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CognitoCredentialsLoadedState value) loaded,
    required TResult Function(CognitoCredentialsLoadingState value) loading,
    required TResult Function(CognitoCredentialsReloadingState value) reloading,
    required TResult Function(CognitoCredentialsInitialState value) initial,
  }) {
    return reloading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CognitoCredentialsLoadedState value)? loaded,
    TResult? Function(CognitoCredentialsLoadingState value)? loading,
    TResult? Function(CognitoCredentialsReloadingState value)? reloading,
    TResult? Function(CognitoCredentialsInitialState value)? initial,
  }) {
    return reloading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CognitoCredentialsLoadedState value)? loaded,
    TResult Function(CognitoCredentialsLoadingState value)? loading,
    TResult Function(CognitoCredentialsReloadingState value)? reloading,
    TResult Function(CognitoCredentialsInitialState value)? initial,
    required TResult orElse(),
  }) {
    if (reloading != null) {
      return reloading(this);
    }
    return orElse();
  }
}

abstract class CognitoCredentialsReloadingState
    implements CognitoCredentialsState {
  const factory CognitoCredentialsReloadingState(
      {required final CognitoCredentialsEntity credentials,
      required final CancelableOperation<
              Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
          operation}) = _$CognitoCredentialsReloadingState;

  CognitoCredentialsEntity get credentials;
  CancelableOperation<
      Either<CognitoCredentialsEntity, NetworkConnectionFailure>> get operation;
  @JsonKey(ignore: true)
  _$$CognitoCredentialsReloadingStateCopyWith<
          _$CognitoCredentialsReloadingState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CognitoCredentialsInitialStateCopyWith<$Res> {
  factory _$$CognitoCredentialsInitialStateCopyWith(
          _$CognitoCredentialsInitialState value,
          $Res Function(_$CognitoCredentialsInitialState) then) =
      __$$CognitoCredentialsInitialStateCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CognitoCredentialsInitialStateCopyWithImpl<$Res>
    extends _$CognitoCredentialsStateCopyWithImpl<$Res,
        _$CognitoCredentialsInitialState>
    implements _$$CognitoCredentialsInitialStateCopyWith<$Res> {
  __$$CognitoCredentialsInitialStateCopyWithImpl(
      _$CognitoCredentialsInitialState _value,
      $Res Function(_$CognitoCredentialsInitialState) _then)
      : super(_value, _then);
}

/// @nodoc

class _$CognitoCredentialsInitialState
    with DiagnosticableTreeMixin
    implements CognitoCredentialsInitialState {
  const _$CognitoCredentialsInitialState();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CognitoCredentialsState.initial()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty('type', 'CognitoCredentialsState.initial'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CognitoCredentialsInitialState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(CognitoCredentialsEntity credentials) loaded,
    required TResult Function(
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)
        loading,
    required TResult Function(
            CognitoCredentialsEntity credentials,
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)
        reloading,
    required TResult Function() initial,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(CognitoCredentialsEntity credentials)? loaded,
    TResult? Function(
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)?
        loading,
    TResult? Function(
            CognitoCredentialsEntity credentials,
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)?
        reloading,
    TResult? Function()? initial,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(CognitoCredentialsEntity credentials)? loaded,
    TResult Function(
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)?
        loading,
    TResult Function(
            CognitoCredentialsEntity credentials,
            CancelableOperation<
                    Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
                operation)?
        reloading,
    TResult Function()? initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CognitoCredentialsLoadedState value) loaded,
    required TResult Function(CognitoCredentialsLoadingState value) loading,
    required TResult Function(CognitoCredentialsReloadingState value) reloading,
    required TResult Function(CognitoCredentialsInitialState value) initial,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CognitoCredentialsLoadedState value)? loaded,
    TResult? Function(CognitoCredentialsLoadingState value)? loading,
    TResult? Function(CognitoCredentialsReloadingState value)? reloading,
    TResult? Function(CognitoCredentialsInitialState value)? initial,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CognitoCredentialsLoadedState value)? loaded,
    TResult Function(CognitoCredentialsLoadingState value)? loading,
    TResult Function(CognitoCredentialsReloadingState value)? reloading,
    TResult Function(CognitoCredentialsInitialState value)? initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class CognitoCredentialsInitialState
    implements CognitoCredentialsState {
  const factory CognitoCredentialsInitialState() =
      _$CognitoCredentialsInitialState;
}
