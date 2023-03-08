import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import '../../../../entities/entities.dart';

part 'event.freezed.dart';

@freezed
class CognitoCredentialsEvent with _$CognitoCredentialsEvent {
  const factory CognitoCredentialsEvent.loaded({
    required CognitoCredentialsEntity response,
  }) = CognitoCredentialsLoadedEvent;

  const factory CognitoCredentialsEvent.networkFailure() =
      CognitoCredentialsNetworkFailureEvent;

  const factory CognitoCredentialsEvent.load() = CognitoCredentialsLoadEvent;
}
