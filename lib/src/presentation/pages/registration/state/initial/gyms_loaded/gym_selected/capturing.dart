import 'package:async/async.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../../../../../domain/entities/entities.dart';
import 'gym_selected.dart';

/// This is the state of the registration page when the user is taking a picture.
class CapturingState extends GymSelectedState {
  /// This is the photo capture operation.
  final CancelableOperation<XFile> photoCapture;

  const CapturingState({
    required super.firstNameConfirmed,
    required super.location,
    required super.gyms,
    required super.currentPage,
    required super.autovalidateMode,
    required super.gym,
    required super.gymConfirmed,
    required super.cameraController,
    required super.hasReadPhotoInstructions,
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
    required this.photoCapture,
  }) : super();

  CapturingState copyWith({
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
    CancelableOperation<XFile>? photoCapture,
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
      CapturingState(
        firstNameConfirmed: firstNameConfirmed ?? super.firstNameConfirmed,
        location: location ?? super.location,
        gyms: gyms ?? super.gyms,
        currentPage: currentPage ?? super.currentPage,
        autovalidateMode: autovalidateMode ?? super.autovalidateMode,
        gym: gym ?? super.gym,
        gymConfirmed: gymConfirmed ?? super.gymConfirmed,
        cameraController: cameraController ?? super.cameraController,
        hasReadPhotoInstructions:
            hasReadPhotoInstructions ?? super.hasReadPhotoInstructions,
        takenEmails: takenEmails ?? super.takenEmails,
        photoCapture: photoCapture ?? this.photoCapture,
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
      [super.props, photoCapture.isCompleted, photoCapture.isCanceled];
}
