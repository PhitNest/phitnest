import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../../../../../domain/entities/entities.dart';
import '../gyms_loaded.dart';

export 'capturing.dart';
export 'capture_error.dart';
export 'camera_error.dart';
export 'photo_selected/photo_selected.dart';

/// This is the state of the registration page when the user has selected a gym.
class GymSelectedState extends GymsLoadedState {
  /// This is the currently selected gym
  final GymEntity gym;

  /// This is whether or not the user has confirmed that they belong to this gym
  final bool gymConfirmed;

  /// This is the controller for the camera on page 6
  final CameraController cameraController;

  /// This is whether or not the user has read the instructions for taking a
  /// profile picture.
  final bool hasReadPhotoInstructions;

  /// These are the emails that the backend has already responded with UsernameExistsException
  /// for.
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
    required this.gymConfirmed,
    required this.cameraController,
    required this.hasReadPhotoInstructions,
    required this.takenEmails,
  }) : super();

  GymSelectedState copyWith({
    bool? firstNameConfirmed,
    LocationEntity? location,
    List<GymEntity>? gyms,
    int? currentPage,
    AutovalidateMode? autovalidateMode,
    GymEntity? gym,
    bool? gymConfirmed,
    CameraController? cameraController,
    bool? hasReadPhotoInstructions,
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
        gymConfirmed: gymConfirmed ?? this.gymConfirmed,
        cameraController: cameraController ?? this.cameraController,
        hasReadPhotoInstructions:
            hasReadPhotoInstructions ?? this.hasReadPhotoInstructions,
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
  List<Object> get props =>
      [super.props, gym, gymConfirmed, hasReadPhotoInstructions, takenEmails];
}
