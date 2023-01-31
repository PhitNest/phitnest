import 'package:flutter/material.dart';

import 'registration_state.dart';

/// Base class for when user is entering registration information and
/// sending a registration request.
abstract class InitialState extends RegistrationState {
  /// Whether or not the user has a valid first name. This is necessary
  /// because later pages reference the user's first name.
  final bool firstNameConfirmed;

  /// The current page the user is on. This is needed for the page indicator
  /// widget.
  final int currentPage;

  /// Controls whether or not the form fields should show validation error
  /// messages.
  final AutovalidateMode autovalidateMode;

  // Controllers for the form fields.
  final firstNameController;
  final lastNameController;
  final emailController;
  final passwordController;
  final confirmPasswordController;
  final pageController;
  final pageOneFormKey;
  final pageTwoFormKey;
  final firstNameFocusNode;
  final lastNameFocusNode;
  final emailFocusNode;
  final passwordFocusNode;
  final confirmPasswordFocusNode;

  const InitialState({
    required this.firstNameConfirmed,
    required this.currentPage,
    required this.autovalidateMode,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.pageController,
    required this.pageOneFormKey,
    required this.pageTwoFormKey,
    required this.firstNameFocusNode,
    required this.lastNameFocusNode,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.confirmPasswordFocusNode,
  }) : super();

  @override
  List<Object?> get props =>
      [firstNameConfirmed, currentPage, autovalidateMode];
}
