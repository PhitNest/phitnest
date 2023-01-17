import 'package:flutter/material.dart';

import '../bloc_state.dart';

abstract class RegistrationState extends BlocState {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final PageController pageController;
  final GlobalKey<FormState> pageOneFormKey;
  final GlobalKey<FormState> pageTwoFormKey;
  final AutovalidateMode autovalidateMode;
  final FocusNode firstNameFocusNode;
  final FocusNode lastNameFocusNode;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode confirmPasswordFocusNode;
  final bool scrollEnabled;
  final int pageIndex;

  const RegistrationState({
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.pageController,
    required this.pageOneFormKey,
    required this.pageTwoFormKey,
    required this.autovalidateMode,
    required this.pageIndex,
    required this.scrollEnabled,
    required this.firstNameFocusNode,
    required this.lastNameFocusNode,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.confirmPasswordFocusNode,
  }) : super();

  @override
  List<Object> get props => [
        firstNameController,
        lastNameController,
        emailController,
        passwordController,
        confirmPasswordController,
        pageController,
        pageOneFormKey,
        pageTwoFormKey,
        autovalidateMode,
        pageIndex,
        scrollEnabled,
        firstNameFocusNode,
        lastNameFocusNode,
        emailFocusNode,
        passwordFocusNode,
        confirmPasswordFocusNode,
      ];

  @override
  Future<void> dispose() {
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
    pageController.dispose();
    return super.dispose();
  }
}

class RegistrationInitial extends RegistrationState {
  const RegistrationInitial({
    required super.autovalidateMode,
    required super.confirmPasswordController,
    required super.emailController,
    required super.firstNameController,
    required super.lastNameController,
    required super.passwordController,
    required super.pageIndex,
    required super.pageOneFormKey,
    required super.pageTwoFormKey,
    required super.scrollEnabled,
    required super.firstNameFocusNode,
    required super.lastNameFocusNode,
    required super.emailFocusNode,
    required super.passwordFocusNode,
    required super.confirmPasswordFocusNode,
    required super.pageController,
  }) : super();

  RegistrationInitial copyWith({
    TextEditingController? firstNameController,
    TextEditingController? lastNameController,
    TextEditingController? emailController,
    TextEditingController? passwordController,
    TextEditingController? confirmPasswordController,
    AutovalidateMode? autovalidateMode,
    int? pageIndex,
    GlobalKey<FormState>? pageOneFormKey,
    GlobalKey<FormState>? pageTwoFormKey,
    bool? scrollEnabled,
    FocusNode? firstNameFocusNode,
    FocusNode? lastNameFocusNode,
    FocusNode? emailFocusNode,
    FocusNode? passwordFocusNode,
    FocusNode? confirmPasswordFocusNode,
    PageController? pageController,
  }) =>
      RegistrationInitial(
        firstNameController: firstNameController ?? this.firstNameController,
        lastNameController: lastNameController ?? this.lastNameController,
        emailController: emailController ?? this.emailController,
        passwordController: passwordController ?? this.passwordController,
        confirmPasswordController:
            confirmPasswordController ?? this.confirmPasswordController,
        autovalidateMode: autovalidateMode ?? this.autovalidateMode,
        pageIndex: pageIndex ?? this.pageIndex,
        pageOneFormKey: pageOneFormKey ?? this.pageOneFormKey,
        pageTwoFormKey: pageTwoFormKey ?? this.pageTwoFormKey,
        scrollEnabled: scrollEnabled ?? this.scrollEnabled,
        firstNameFocusNode: firstNameFocusNode ?? this.firstNameFocusNode,
        lastNameFocusNode: lastNameFocusNode ?? this.lastNameFocusNode,
        emailFocusNode: emailFocusNode ?? this.emailFocusNode,
        passwordFocusNode: passwordFocusNode ?? this.passwordFocusNode,
        confirmPasswordFocusNode:
            confirmPasswordFocusNode ?? this.confirmPasswordFocusNode,
        pageController: pageController ?? this.pageController,
      );
}
