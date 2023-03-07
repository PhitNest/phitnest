import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'failure.freezed.dart';

@freezed
class GetCognitoCredentialsFailure with _$GetCognitoCredentialsFailure {
  const factory GetCognitoCredentialsFailure.sandbox() =
      GetCognitoCredentialsFailureSandbox;

  const factory GetCognitoCredentialsFailure.unknown() =
      GetCognitoCredentialsFailureUnknown;
}
