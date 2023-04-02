import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:phitnest_utils/utils.dart';

part 'response.freezed.dart';

@freezed
class ConfirmEmailResponse with _$ConfirmEmailResponse {
  const factory ConfirmEmailResponse.success() = ConfirmEmailResponseSuccess;

  const factory ConfirmEmailResponse.sandbox() = ConfirmEmailResponseSandbox;

  @Implements<Failure>()
  const factory ConfirmEmailResponse.incorrectCode({
    @Default("The code you entered is incorrect") String message,
  }) = ConfirmEmailResponseIncorrectCode;

  @Implements<Failure>()
  const factory ConfirmEmailResponse.invalidCognitoPool({
    @Default("Invalid cognito credentials") String message,
  }) = ConfirmEmailResponseInvalidPool;
}
