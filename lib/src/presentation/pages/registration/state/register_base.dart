import 'package:flutter/material.dart';

import 'registration_state.dart';

abstract class RegistrationBase extends RegistrationState {
  final bool firstNameConfirmed;
  final int currentPage;
  final AutovalidateMode autovalidateMode;

  const RegistrationBase({
    required this.firstNameConfirmed,
    required this.currentPage,
    required this.autovalidateMode,
  }) : super();

  @override
  List<Object?> get props =>
      [firstNameConfirmed, currentPage, autovalidateMode];
}
