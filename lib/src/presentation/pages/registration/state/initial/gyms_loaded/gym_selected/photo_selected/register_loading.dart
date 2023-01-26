import 'package:async/async.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../common/failure.dart';
import '../../../../../../../../data/data_sources/auth/auth.dart';
import '../../../../../../../../domain/entities/entities.dart';
import 'photo_selected.dart';

/// This is the state for the when the register request is loading.
class RegisterRequestLoadingState extends PhotoSelectedState {
  /// This is the register request.
  final CancelableOperation<Either<RegisterResponse, Failure>> registerOp;

  const RegisterRequestLoadingState({
    required super.autovalidateMode,
    required super.gym,
    required super.gyms,
    required super.takenEmails,
    required super.gymConfirmed,
    required super.firstNameConfirmed,
    required super.currentPage,
    required super.location,
    required super.cameraController,
    required super.hasReadPhotoInstructions,
    required super.photo,
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
    required this.registerOp,
  }) : super();

  RegisterRequestLoadingState copyWith({
    AutovalidateMode? autovalidateMode,
    GymEntity? gym,
    List<GymEntity>? gyms,
    bool? gymConfirmed,
    bool? firstNameConfirmed,
    int? currentPage,
    Set<String>? takenEmails,
    LocationEntity? location,
    CameraController? cameraController,
    bool? hasReadPhotoInstructions,
    XFile? photo,
    CancelableOperation<Either<RegisterResponse, Failure>>? registerOp,
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
      RegisterRequestLoadingState(
        autovalidateMode: autovalidateMode ?? super.autovalidateMode,
        gym: gym ?? super.gym,
        gyms: gyms ?? super.gyms,
        gymConfirmed: gymConfirmed ?? super.gymConfirmed,
        firstNameConfirmed: firstNameConfirmed ?? super.firstNameConfirmed,
        currentPage: currentPage ?? super.currentPage,
        takenEmails: takenEmails ?? super.takenEmails,
        location: location ?? super.location,
        cameraController: cameraController ?? super.cameraController,
        hasReadPhotoInstructions:
            hasReadPhotoInstructions ?? super.hasReadPhotoInstructions,
        photo: photo ?? super.photo,
        registerOp: registerOp ?? this.registerOp,
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
  List<Object> get props => [
        super.props,
        registerOp.isCompleted,
        registerOp.isCanceled,
      ];
}
