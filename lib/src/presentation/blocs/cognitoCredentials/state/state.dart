import 'package:async/async.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:phitnest_utils/utils.dart';

import '../../../../entities/entities.dart';

part 'state.freezed.dart';

@freezed
class CognitoCredentialsState with _$CognitoCredentialsState {
  const factory CognitoCredentialsState.loaded({
    required CognitoCredentialsEntity credentials,
  }) = CognitoCredentialsLoadedState;

  const factory CognitoCredentialsState.loading({
    required CancelableOperation<
            Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
        operation,
  }) = CognitoCredentialsLoadingState;

  const factory CognitoCredentialsState.reloading({
    required CognitoCredentialsEntity credentials,
    required CancelableOperation<
            Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
        operation,
  }) = CognitoCredentialsReloadingState;

  const factory CognitoCredentialsState.initial() =
      CognitoCredentialsInitialState;
}
