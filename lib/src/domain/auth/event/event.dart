import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import '../../../data/auth/auth.dart';

part 'event.freezed.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.loadedServerStatus({
    required ServerStatus serverStatus,
  }) = ServerStatusLoaded;

  const factory AuthEvent.networkFailure() = AuthEventNetworkFailure;
}
