import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'user.dart';

sealed class GetUserResponse extends Equatable {
  final User user;

  const GetUserResponse(this.user) : super();

  @override
  List<Object?> get props => [user];
}

final class GetUserSuccess extends GetUserResponse {
  final Image profilePicture;

  const GetUserSuccess(super.user, this.profilePicture) : super();

  @override
  List<Object?> get props => [user, profilePicture];
}

final class FailedToLoadProfilePicture extends GetUserResponse {
  const FailedToLoadProfilePicture(super.user) : super();
}
