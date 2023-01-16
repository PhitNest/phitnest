import 'package:flutter/material.dart';

import '../bloc_state.dart';

abstract class OnBoardingState extends BlocState {
  const OnBoardingState() : super();

  @override
  List<Object> get props => [];
}

class OnBoardingIntroState extends OnBoardingState {
  const OnBoardingIntroState() : super();
}

class OnBoardingRegistrationState extends OnBoardingState {
  final PageController pageController;
  final int pageIndex;
  final bool scrollEnabled;
  final GlobalKey<FormState> pageOneFormKey;
  final GlobalKey<FormState> pageTwoFormKey;
  final AutovalidateMode autovalidateMode;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final FocusNode firstNameFocusNode;
  final FocusNode lastNameFocusNode;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode confirmPasswordFocusNode;

  const OnBoardingRegistrationState({
    required this.pageController,
    required this.pageIndex,
    required this.scrollEnabled,
    required this.pageOneFormKey,
    required this.pageTwoFormKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.firstNameFocusNode,
    required this.lastNameFocusNode,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.confirmPasswordFocusNode,
    this.autovalidateMode = AutovalidateMode.disabled,
  }) : super();

  @override
  List<Object> get props => [
        ...super.props,
        autovalidateMode,
        pageController,
        pageIndex,
        scrollEnabled,
        pageOneFormKey,
        pageTwoFormKey,
        firstNameController,
        lastNameController,
        emailController,
        passwordController,
        confirmPasswordController,
        firstNameFocusNode,
        lastNameFocusNode,
        emailFocusNode,
        passwordFocusNode,
        confirmPasswordFocusNode,
      ];

  OnBoardingRegistrationState copyWith({
    AutovalidateMode? autovalidateMode,
    PageController? pageController,
    int? pageIndex,
    bool? scrollEnabled,
    GlobalKey<FormState>? pageOneFormKey,
    GlobalKey<FormState>? pageTwoFormKey,
    TextEditingController? firstNameController,
    TextEditingController? lastNameController,
    TextEditingController? emailController,
    TextEditingController? passwordController,
    TextEditingController? confirmPasswordController,
    FocusNode? firstNameFocusNode,
    FocusNode? lastNameFocusNode,
    FocusNode? emailFocusNode,
    FocusNode? passwordFocusNode,
    FocusNode? confirmPasswordFocusNode,
  }) =>
      OnBoardingRegistrationState(
        autovalidateMode: autovalidateMode ?? this.autovalidateMode,
        pageController: pageController ?? this.pageController,
        pageIndex: pageIndex ?? this.pageIndex,
        scrollEnabled: scrollEnabled ?? this.scrollEnabled,
        pageOneFormKey: pageOneFormKey ?? this.pageOneFormKey,
        pageTwoFormKey: pageTwoFormKey ?? this.pageTwoFormKey,
        firstNameController: firstNameController ?? this.firstNameController,
        lastNameController: lastNameController ?? this.lastNameController,
        emailController: emailController ?? this.emailController,
        passwordController: passwordController ?? this.passwordController,
        confirmPasswordController:
            confirmPasswordController ?? this.confirmPasswordController,
        firstNameFocusNode: firstNameFocusNode ?? this.firstNameFocusNode,
        lastNameFocusNode: lastNameFocusNode ?? this.lastNameFocusNode,
        emailFocusNode: emailFocusNode ?? this.emailFocusNode,
        passwordFocusNode: passwordFocusNode ?? this.passwordFocusNode,
        confirmPasswordFocusNode:
            confirmPasswordFocusNode ?? this.confirmPasswordFocusNode,
      );

  @override
  Future<void> dispose() async {
    pageController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    await super.dispose();
  }
}
