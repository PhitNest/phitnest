import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../../../../../common/failure.dart';
import '../../../../../../../domain/entities/entities.dart';
import 'gym_selected.dart';

/// This is the state that occurs when the camera fails to load.
class CameraErrorState extends GymSelectedState {
  final Failure failure;

  CameraErrorState({
    required super.firstNameConfirmed,
    required super.location,
    required super.gyms,
    required super.currentPage,
    required super.autovalidateMode,
    required super.gym,
    required super.gymConfirmed,
    required super.takenEmails,
    required super.cameraController,
    required super.hasReadPhotoInstructions,
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

  CameraErrorState copyWith({
    bool? firstNameConfirmed,
    LocationEntity? location,
    List<GymEntity>? gyms,
    int? currentPage,
    AutovalidateMode? autovalidateMode,
    GymEntity? gym,
    bool? gymConfirmed,
    Set<String>? takenEmails,
    CameraController? cameraController,
    bool? hasReadPhotoInstructions,
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
      CameraErrorState(
        firstNameConfirmed: firstNameConfirmed ?? super.firstNameConfirmed,
        location: location ?? super.location,
        gyms: gyms ?? super.gyms,
        currentPage: currentPage ?? super.currentPage,
        autovalidateMode: autovalidateMode ?? super.autovalidateMode,
        gym: gym ?? super.gym,
        gymConfirmed: gymConfirmed ?? super.gymConfirmed,
        takenEmails: takenEmails ?? super.takenEmails,
        cameraController: cameraController ?? super.cameraController,
        hasReadPhotoInstructions:
            hasReadPhotoInstructions ?? super.hasReadPhotoInstructions,
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
