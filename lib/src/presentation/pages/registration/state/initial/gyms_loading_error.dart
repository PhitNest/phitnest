import 'package:flutter/material.dart';

import '../../../../../common/failure.dart';
import 'initial.dart';

/// This is the state when loading gyms fails.
class GymsLoadingErrorState extends InitialState {
  final Failure failure;

  const GymsLoadingErrorState({
    required super.firstNameConfirmed,
    required super.currentPage,
    required super.autovalidateMode,
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
    required this.failure,
  }) : super();

  GymsLoadingErrorState copyWith({
    bool? firstNameConfirmed,
    int? currentPage,
    AutovalidateMode? autovalidateMode,
    Failure? failure,
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
      GymsLoadingErrorState(
        firstNameConfirmed: firstNameConfirmed ?? super.firstNameConfirmed,
        currentPage: currentPage ?? super.currentPage,
        autovalidateMode: autovalidateMode ?? super.autovalidateMode,
        failure: failure ?? this.failure,
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
  List<Object?> get props => [super.props, failure];
}
