import 'package:async/async.dart';
import 'package:flutter/material.dart';

import '../../../../../domain/use_cases/use_cases.dart';
import 'initial.dart';

/// This is the state of the registration page when the user is loading gyms.
/// At this point the user should not be able to scroll past page 3.
class GymsLoadingState extends InitialState {
  /// Loading gyms
  final CancelableOperation<LocationAndGymsResponse> loadGymsOp;

  const GymsLoadingState({
    required super.firstNameController,
    required super.lastNameController,
    required super.emailController,
    required super.passwordController,
    required super.confirmPasswordController,
    required super.firstNameFocusNode,
    required super.lastNameFocusNode,
    required super.emailFocusNode,
    required super.passwordFocusNode,
    required super.confirmPasswordFocusNode,
    required super.pageController,
    required super.pageOneFormKey,
    required super.pageTwoFormKey,
    required super.firstNameConfirmed,
    required super.currentPage,
    required super.autovalidateMode,
    required this.loadGymsOp,
  }) : super();

  GymsLoadingState copyWith({
    bool? firstNameConfirmed,
    int? currentPage,
    AutovalidateMode? autovalidateMode,
    CancelableOperation<LocationAndGymsResponse>? loadGymsOp,
    TextEditingController? firstNameController,
    TextEditingController? lastNameController,
    TextEditingController? emailController,
    TextEditingController? passwordController,
    TextEditingController? confirmPasswordController,
    PageController? pageController,
    GlobalKey<FormState>? pageOneFormKey,
    GlobalKey<FormState>? pageTwoFormKey,
    FocusNode? firstNameFocusNode,
    FocusNode? lastNameFocusNode,
    FocusNode? emailFocusNode,
    FocusNode? passwordFocusNode,
    FocusNode? confirmPasswordFocusNode,
  }) =>
      GymsLoadingState(
        firstNameConfirmed: firstNameConfirmed ?? super.firstNameConfirmed,
        currentPage: currentPage ?? super.currentPage,
        autovalidateMode: autovalidateMode ?? super.autovalidateMode,
        loadGymsOp: loadGymsOp ?? this.loadGymsOp,
        firstNameController: firstNameController ?? super.firstNameController,
        lastNameController: lastNameController ?? super.lastNameController,
        emailController: emailController ?? super.emailController,
        passwordController: passwordController ?? super.passwordController,
        confirmPasswordController:
            confirmPasswordController ?? super.confirmPasswordController,
        pageController: pageController ?? super.pageController,
        pageOneFormKey: pageOneFormKey ?? super.pageOneFormKey,
        pageTwoFormKey: pageTwoFormKey ?? super.pageTwoFormKey,
        firstNameFocusNode: firstNameFocusNode ?? super.firstNameFocusNode,
        lastNameFocusNode: lastNameFocusNode ?? super.lastNameFocusNode,
        emailFocusNode: emailFocusNode ?? super.emailFocusNode,
        passwordFocusNode: passwordFocusNode ?? super.passwordFocusNode,
        confirmPasswordFocusNode:
            confirmPasswordFocusNode ?? super.confirmPasswordFocusNode,
      );

  @override
  List<Object?> get props =>
      [super.props, loadGymsOp.isCompleted, loadGymsOp.isCanceled];
}
