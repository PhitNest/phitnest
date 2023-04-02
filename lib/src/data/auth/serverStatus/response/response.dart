import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'response.freezed.dart';

@freezed
class ServerStatus with _$ServerStatus {
  const factory ServerStatus.live({
    required String userPoolId,
    required String clientId,
  }) = ServerStatusLive;

  const factory ServerStatus.sandbox() = ServerStatusSandbox;
}
