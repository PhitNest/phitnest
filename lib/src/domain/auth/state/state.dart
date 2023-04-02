import 'package:async/async.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:phitnest_utils/utils.dart';

import '../../../data/auth/auth.dart';

part 'state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.loadedServerStatus({
    required ServerStatus serverStatus,
  }) = ServerStatusStateLoaded;

  const factory AuthState.loadingServerStatus({
    required CancelableOperation<Either<ServerStatus, NetworkConnectionFailure>>
        operation,
  }) = ServerStatusStateLoading;
}
