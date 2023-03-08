// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CognitoCredentialsEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(CognitoCredentialsEntity response) loaded,
    required TResult Function() networkFailure,
    required TResult Function() load,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(CognitoCredentialsEntity response)? loaded,
    TResult? Function()? networkFailure,
    TResult? Function()? load,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(CognitoCredentialsEntity response)? loaded,
    TResult Function()? networkFailure,
    TResult Function()? load,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CognitoCredentialsLoadedEvent value) loaded,
    required TResult Function(CognitoCredentialsNetworkFailureEvent value)
        networkFailure,
    required TResult Function(CognitoCredentialsLoadEvent value) load,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CognitoCredentialsLoadedEvent value)? loaded,
    TResult? Function(CognitoCredentialsNetworkFailureEvent value)?
        networkFailure,
    TResult? Function(CognitoCredentialsLoadEvent value)? load,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CognitoCredentialsLoadedEvent value)? loaded,
    TResult Function(CognitoCredentialsNetworkFailureEvent value)?
        networkFailure,
    TResult Function(CognitoCredentialsLoadEvent value)? load,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CognitoCredentialsEventCopyWith<$Res> {
  factory $CognitoCredentialsEventCopyWith(CognitoCredentialsEvent value,
          $Res Function(CognitoCredentialsEvent) then) =
      _$CognitoCredentialsEventCopyWithImpl<$Res, CognitoCredentialsEvent>;
}

/// @nodoc
class _$CognitoCredentialsEventCopyWithImpl<$Res,
        $Val extends CognitoCredentialsEvent>
    implements $CognitoCredentialsEventCopyWith<$Res> {
  _$CognitoCredentialsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$CognitoCredentialsLoadedEventCopyWith<$Res> {
  factory _$$CognitoCredentialsLoadedEventCopyWith(
          _$CognitoCredentialsLoadedEvent value,
          $Res Function(_$CognitoCredentialsLoadedEvent) then) =
      __$$CognitoCredentialsLoadedEventCopyWithImpl<$Res>;
  @useResult
  $Res call({CognitoCredentialsEntity response});

  $CognitoCredentialsEntityCopyWith<$Res> get response;
}

/// @nodoc
class __$$CognitoCredentialsLoadedEventCopyWithImpl<$Res>
    extends _$CognitoCredentialsEventCopyWithImpl<$Res,
        _$CognitoCredentialsLoadedEvent>
    implements _$$CognitoCredentialsLoadedEventCopyWith<$Res> {
  __$$CognitoCredentialsLoadedEventCopyWithImpl(
      _$CognitoCredentialsLoadedEvent _value,
      $Res Function(_$CognitoCredentialsLoadedEvent) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? response = null,
  }) {
    return _then(_$CognitoCredentialsLoadedEvent(
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as CognitoCredentialsEntity,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $CognitoCredentialsEntityCopyWith<$Res> get response {
    return $CognitoCredentialsEntityCopyWith<$Res>(_value.response, (value) {
      return _then(_value.copyWith(response: value));
    });
  }
}

/// @nodoc

class _$CognitoCredentialsLoadedEvent
    with DiagnosticableTreeMixin
    implements CognitoCredentialsLoadedEvent {
  const _$CognitoCredentialsLoadedEvent({required this.response});

  @override
  final CognitoCredentialsEntity response;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CognitoCredentialsEvent.loaded(response: $response)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CognitoCredentialsEvent.loaded'))
      ..add(DiagnosticsProperty('response', response));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CognitoCredentialsLoadedEvent &&
            (identical(other.response, response) ||
                other.response == response));
  }

  @override
  int get hashCode => Object.hash(runtimeType, response);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CognitoCredentialsLoadedEventCopyWith<_$CognitoCredentialsLoadedEvent>
      get copyWith => __$$CognitoCredentialsLoadedEventCopyWithImpl<
          _$CognitoCredentialsLoadedEvent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(CognitoCredentialsEntity response) loaded,
    required TResult Function() networkFailure,
    required TResult Function() load,
  }) {
    return loaded(response);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(CognitoCredentialsEntity response)? loaded,
    TResult? Function()? networkFailure,
    TResult? Function()? load,
  }) {
    return loaded?.call(response);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(CognitoCredentialsEntity response)? loaded,
    TResult Function()? networkFailure,
    TResult Function()? load,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(response);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CognitoCredentialsLoadedEvent value) loaded,
    required TResult Function(CognitoCredentialsNetworkFailureEvent value)
        networkFailure,
    required TResult Function(CognitoCredentialsLoadEvent value) load,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CognitoCredentialsLoadedEvent value)? loaded,
    TResult? Function(CognitoCredentialsNetworkFailureEvent value)?
        networkFailure,
    TResult? Function(CognitoCredentialsLoadEvent value)? load,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CognitoCredentialsLoadedEvent value)? loaded,
    TResult Function(CognitoCredentialsNetworkFailureEvent value)?
        networkFailure,
    TResult Function(CognitoCredentialsLoadEvent value)? load,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class CognitoCredentialsLoadedEvent
    implements CognitoCredentialsEvent {
  const factory CognitoCredentialsLoadedEvent(
          {required final CognitoCredentialsEntity response}) =
      _$CognitoCredentialsLoadedEvent;

  CognitoCredentialsEntity get response;
  @JsonKey(ignore: true)
  _$$CognitoCredentialsLoadedEventCopyWith<_$CognitoCredentialsLoadedEvent>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CognitoCredentialsNetworkFailureEventCopyWith<$Res> {
  factory _$$CognitoCredentialsNetworkFailureEventCopyWith(
          _$CognitoCredentialsNetworkFailureEvent value,
          $Res Function(_$CognitoCredentialsNetworkFailureEvent) then) =
      __$$CognitoCredentialsNetworkFailureEventCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CognitoCredentialsNetworkFailureEventCopyWithImpl<$Res>
    extends _$CognitoCredentialsEventCopyWithImpl<$Res,
        _$CognitoCredentialsNetworkFailureEvent>
    implements _$$CognitoCredentialsNetworkFailureEventCopyWith<$Res> {
  __$$CognitoCredentialsNetworkFailureEventCopyWithImpl(
      _$CognitoCredentialsNetworkFailureEvent _value,
      $Res Function(_$CognitoCredentialsNetworkFailureEvent) _then)
      : super(_value, _then);
}

/// @nodoc

class _$CognitoCredentialsNetworkFailureEvent
    with DiagnosticableTreeMixin
    implements CognitoCredentialsNetworkFailureEvent {
  const _$CognitoCredentialsNetworkFailureEvent();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CognitoCredentialsEvent.networkFailure()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty('type', 'CognitoCredentialsEvent.networkFailure'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CognitoCredentialsNetworkFailureEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(CognitoCredentialsEntity response) loaded,
    required TResult Function() networkFailure,
    required TResult Function() load,
  }) {
    return networkFailure();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(CognitoCredentialsEntity response)? loaded,
    TResult? Function()? networkFailure,
    TResult? Function()? load,
  }) {
    return networkFailure?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(CognitoCredentialsEntity response)? loaded,
    TResult Function()? networkFailure,
    TResult Function()? load,
    required TResult orElse(),
  }) {
    if (networkFailure != null) {
      return networkFailure();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CognitoCredentialsLoadedEvent value) loaded,
    required TResult Function(CognitoCredentialsNetworkFailureEvent value)
        networkFailure,
    required TResult Function(CognitoCredentialsLoadEvent value) load,
  }) {
    return networkFailure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CognitoCredentialsLoadedEvent value)? loaded,
    TResult? Function(CognitoCredentialsNetworkFailureEvent value)?
        networkFailure,
    TResult? Function(CognitoCredentialsLoadEvent value)? load,
  }) {
    return networkFailure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CognitoCredentialsLoadedEvent value)? loaded,
    TResult Function(CognitoCredentialsNetworkFailureEvent value)?
        networkFailure,
    TResult Function(CognitoCredentialsLoadEvent value)? load,
    required TResult orElse(),
  }) {
    if (networkFailure != null) {
      return networkFailure(this);
    }
    return orElse();
  }
}

abstract class CognitoCredentialsNetworkFailureEvent
    implements CognitoCredentialsEvent {
  const factory CognitoCredentialsNetworkFailureEvent() =
      _$CognitoCredentialsNetworkFailureEvent;
}

/// @nodoc
abstract class _$$CognitoCredentialsLoadEventCopyWith<$Res> {
  factory _$$CognitoCredentialsLoadEventCopyWith(
          _$CognitoCredentialsLoadEvent value,
          $Res Function(_$CognitoCredentialsLoadEvent) then) =
      __$$CognitoCredentialsLoadEventCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CognitoCredentialsLoadEventCopyWithImpl<$Res>
    extends _$CognitoCredentialsEventCopyWithImpl<$Res,
        _$CognitoCredentialsLoadEvent>
    implements _$$CognitoCredentialsLoadEventCopyWith<$Res> {
  __$$CognitoCredentialsLoadEventCopyWithImpl(
      _$CognitoCredentialsLoadEvent _value,
      $Res Function(_$CognitoCredentialsLoadEvent) _then)
      : super(_value, _then);
}

/// @nodoc

class _$CognitoCredentialsLoadEvent
    with DiagnosticableTreeMixin
    implements CognitoCredentialsLoadEvent {
  const _$CognitoCredentialsLoadEvent();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CognitoCredentialsEvent.load()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'CognitoCredentialsEvent.load'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CognitoCredentialsLoadEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(CognitoCredentialsEntity response) loaded,
    required TResult Function() networkFailure,
    required TResult Function() load,
  }) {
    return load();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(CognitoCredentialsEntity response)? loaded,
    TResult? Function()? networkFailure,
    TResult? Function()? load,
  }) {
    return load?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(CognitoCredentialsEntity response)? loaded,
    TResult Function()? networkFailure,
    TResult Function()? load,
    required TResult orElse(),
  }) {
    if (load != null) {
      return load();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CognitoCredentialsLoadedEvent value) loaded,
    required TResult Function(CognitoCredentialsNetworkFailureEvent value)
        networkFailure,
    required TResult Function(CognitoCredentialsLoadEvent value) load,
  }) {
    return load(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CognitoCredentialsLoadedEvent value)? loaded,
    TResult? Function(CognitoCredentialsNetworkFailureEvent value)?
        networkFailure,
    TResult? Function(CognitoCredentialsLoadEvent value)? load,
  }) {
    return load?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CognitoCredentialsLoadedEvent value)? loaded,
    TResult Function(CognitoCredentialsNetworkFailureEvent value)?
        networkFailure,
    TResult Function(CognitoCredentialsLoadEvent value)? load,
    required TResult orElse(),
  }) {
    if (load != null) {
      return load(this);
    }
    return orElse();
  }
}

abstract class CognitoCredentialsLoadEvent implements CognitoCredentialsEvent {
  const factory CognitoCredentialsLoadEvent() = _$CognitoCredentialsLoadEvent;
}
