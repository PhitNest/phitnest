import 'package:flutter/material.dart';

import '../../../../../../domain/entities/entities.dart';
import '../initial.dart';

export 'gym_selected/gym_selected.dart';

/// This is the state of the registration page when the user has loaded gyms.
class GymsLoadedState extends InitialState {
  /// This is the users location
  final LocationEntity location;

  /// This is the list of loaded gyms
  final List<GymEntity> gyms;

  const GymsLoadedState({
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
    required this.location,
    required this.gyms,
  }) : super();

  GymsLoadedState copyWith({
    bool? firstNameConfirmed,
    int? currentPage,
    AutovalidateMode? autovalidateMode,
    LocationEntity? location,
    List<GymEntity>? gyms,
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
      GymsLoadedState(
        firstNameConfirmed: firstNameConfirmed ?? super.firstNameConfirmed,
        currentPage: currentPage ?? super.currentPage,
        autovalidateMode: autovalidateMode ?? super.autovalidateMode,
        location: location ?? this.location,
        gyms: gyms ?? this.gyms,
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
  List<Object?> get props => [super.props, location, gyms];
}
