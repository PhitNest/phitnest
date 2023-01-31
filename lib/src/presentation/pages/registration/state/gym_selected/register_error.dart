import 'package:flutter/material.dart';

import '../../../../../common/failure.dart';
import '../../../../../domain/entities/entities.dart';
import 'gym_selected.dart';

/// This is the error that occurs when the registration request fails.
class RegisterRequestErrorState extends GymSelectedState {
  final Failure failure;

  const RegisterRequestErrorState({
    required super.autovalidateMode,
    required super.firstNameConfirmed,
    required super.currentPage,
    required super.gym,
    required super.gyms,
    required super.location,
    required super.takenEmails,
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

  RegisterRequestErrorState copyWith({
    AutovalidateMode? autovalidateMode,
    bool? firstNameConfirmed,
    int? currentPage,
    GymEntity? gym,
    List<GymEntity>? gyms,
    LocationEntity? location,
    Set<String>? takenEmails,
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
      RegisterRequestErrorState(
        autovalidateMode: autovalidateMode ?? this.autovalidateMode,
        firstNameConfirmed: firstNameConfirmed ?? this.firstNameConfirmed,
        currentPage: currentPage ?? this.currentPage,
        gym: gym ?? this.gym,
        gyms: gyms ?? this.gyms,
        location: location ?? this.location,
        takenEmails: takenEmails ?? this.takenEmails,
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
  List<Object> get props => [super.props, failure];
}
