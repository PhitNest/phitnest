import 'package:flutter/material.dart';

import '../../../../../domain/entities/entities.dart';
import '../gyms_loaded.dart';

export 'register_error.dart';
export 'register_loading.dart';

/// This is the state of the registration page when the user has selected a gym.
class GymSelectedState extends GymsLoadedState {
  /// This is the currently selected gym
  final GymEntity gym;

  /// These are the emails that the backend has already responded with UsernameExistsException
  final Set<String> takenEmails;

  const GymSelectedState({
    required super.firstNameConfirmed,
    required super.location,
    required super.gyms,
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
    required this.gym,
    required this.takenEmails,
  }) : super();

  GymSelectedState copyWith({
    bool? firstNameConfirmed,
    LocationEntity? location,
    List<GymEntity>? gyms,
    int? currentPage,
    AutovalidateMode? autovalidateMode,
    GymEntity? gym,
    Set<String>? takenEmails,
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
      GymSelectedState(
        firstNameConfirmed: firstNameConfirmed ?? super.firstNameConfirmed,
        location: location ?? super.location,
        gyms: gyms ?? super.gyms,
        currentPage: currentPage ?? super.currentPage,
        autovalidateMode: autovalidateMode ?? super.autovalidateMode,
        gym: gym ?? this.gym,
        takenEmails: takenEmails ?? this.takenEmails,
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
  List<Object> get props => [super.props, gym, takenEmails];
}
