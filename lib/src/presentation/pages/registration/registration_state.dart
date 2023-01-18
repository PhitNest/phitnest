import 'package:async/async.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/failure.dart';
import '../../../domain/entities/entities.dart';
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
  final int pageIndex;
  final int pageScrollLimit;
  final CancelableOperation<
      Either<Tuple2<List<GymEntity>, LocationEntity>, Failure>> loadGyms;

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
    required this.firstNameFocusNode,
    required this.lastNameFocusNode,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.confirmPasswordFocusNode,
    required this.loadGyms,
    required this.pageScrollLimit,
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
        firstNameFocusNode,
        lastNameFocusNode,
        emailFocusNode,
        passwordFocusNode,
        confirmPasswordFocusNode,
        loadGyms,
        pageScrollLimit,
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
    loadGyms.cancel();
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
    required super.firstNameFocusNode,
    required super.lastNameFocusNode,
    required super.emailFocusNode,
    required super.passwordFocusNode,
    required super.confirmPasswordFocusNode,
    required super.pageController,
    required super.loadGyms,
    required super.pageScrollLimit,
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
    FocusNode? firstNameFocusNode,
    FocusNode? lastNameFocusNode,
    FocusNode? emailFocusNode,
    FocusNode? passwordFocusNode,
    FocusNode? confirmPasswordFocusNode,
    PageController? pageController,
    CancelableOperation<
            Either<Tuple2<List<GymEntity>, LocationEntity>, Failure>>?
        loadGyms,
    int? pageScrollLimit,
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
        firstNameFocusNode: firstNameFocusNode ?? this.firstNameFocusNode,
        lastNameFocusNode: lastNameFocusNode ?? this.lastNameFocusNode,
        emailFocusNode: emailFocusNode ?? this.emailFocusNode,
        passwordFocusNode: passwordFocusNode ?? this.passwordFocusNode,
        confirmPasswordFocusNode:
            confirmPasswordFocusNode ?? this.confirmPasswordFocusNode,
        pageController: pageController ?? this.pageController,
        loadGyms: loadGyms ?? this.loadGyms,
        pageScrollLimit: pageScrollLimit ?? this.pageScrollLimit,
      );
}

class GymsLoaded extends RegistrationInitial {
  final List<GymEntity> gyms;
  final GymEntity? gym;
  final LocationEntity location;
  final bool showMustSelectGymError;
  final CameraController cameraController;

  const GymsLoaded({
    required super.autovalidateMode,
    required super.confirmPasswordController,
    required super.emailController,
    required super.firstNameController,
    required super.lastNameController,
    required super.passwordController,
    required super.pageIndex,
    required super.pageOneFormKey,
    required super.pageTwoFormKey,
    required super.firstNameFocusNode,
    required super.lastNameFocusNode,
    required super.emailFocusNode,
    required super.passwordFocusNode,
    required super.confirmPasswordFocusNode,
    required super.pageController,
    required super.loadGyms,
    required super.pageScrollLimit,
    required this.showMustSelectGymError,
    required this.gyms,
    required this.location,
    required this.cameraController,
    this.gym,
  }) : super();

  GymsLoaded copyWith({
    TextEditingController? firstNameController,
    TextEditingController? lastNameController,
    TextEditingController? emailController,
    TextEditingController? passwordController,
    TextEditingController? confirmPasswordController,
    AutovalidateMode? autovalidateMode,
    int? pageIndex,
    GlobalKey<FormState>? pageOneFormKey,
    GlobalKey<FormState>? pageTwoFormKey,
    FocusNode? firstNameFocusNode,
    FocusNode? lastNameFocusNode,
    FocusNode? emailFocusNode,
    FocusNode? passwordFocusNode,
    FocusNode? confirmPasswordFocusNode,
    PageController? pageController,
    CancelableOperation<
            Either<Tuple2<List<GymEntity>, LocationEntity>, Failure>>?
        loadGyms,
    bool? showMustSelectGymError,
    List<GymEntity>? gyms,
    GymEntity? gym,
    LocationEntity? location,
    int? pageScrollLimit,
    CameraController? cameraController,
  }) =>
      GymsLoaded(
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
        firstNameFocusNode: firstNameFocusNode ?? this.firstNameFocusNode,
        lastNameFocusNode: lastNameFocusNode ?? this.lastNameFocusNode,
        emailFocusNode: emailFocusNode ?? this.emailFocusNode,
        passwordFocusNode: passwordFocusNode ?? this.passwordFocusNode,
        confirmPasswordFocusNode:
            confirmPasswordFocusNode ?? this.confirmPasswordFocusNode,
        gyms: gyms ?? this.gyms,
        pageController: pageController ?? this.pageController,
        loadGyms: loadGyms ?? this.loadGyms,
        gym: gym ?? this.gym,
        showMustSelectGymError:
            showMustSelectGymError ?? this.showMustSelectGymError,
        location: location ?? this.location,
        pageScrollLimit: pageScrollLimit ?? this.pageScrollLimit,
        cameraController: cameraController ?? this.cameraController,
      );

  @override
  List<Object> get props => [
        ...super.props,
        gyms,
        showMustSelectGymError,
        location,
        cameraController,
        ...(gym != null ? [gym!] : []),
      ];
}

class GymsLoadingError extends RegistrationInitial {
  final Failure failure;

  const GymsLoadingError({
    required super.autovalidateMode,
    required super.confirmPasswordController,
    required super.emailController,
    required super.firstNameController,
    required super.lastNameController,
    required super.passwordController,
    required super.pageIndex,
    required super.pageOneFormKey,
    required super.pageTwoFormKey,
    required super.firstNameFocusNode,
    required super.lastNameFocusNode,
    required super.emailFocusNode,
    required super.passwordFocusNode,
    required super.confirmPasswordFocusNode,
    required super.pageController,
    required super.loadGyms,
    required super.pageScrollLimit,
    required this.failure,
  }) : super();

  GymsLoadingError copyWith({
    TextEditingController? firstNameController,
    TextEditingController? lastNameController,
    TextEditingController? emailController,
    TextEditingController? passwordController,
    TextEditingController? confirmPasswordController,
    AutovalidateMode? autovalidateMode,
    int? pageIndex,
    GlobalKey<FormState>? pageOneFormKey,
    GlobalKey<FormState>? pageTwoFormKey,
    FocusNode? firstNameFocusNode,
    FocusNode? lastNameFocusNode,
    FocusNode? emailFocusNode,
    FocusNode? passwordFocusNode,
    FocusNode? confirmPasswordFocusNode,
    PageController? pageController,
    CancelableOperation<
            Either<Tuple2<List<GymEntity>, LocationEntity>, Failure>>?
        loadGyms,
    Failure? failure,
    int? pageScrollLimit,
  }) =>
      GymsLoadingError(
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
        firstNameFocusNode: firstNameFocusNode ?? this.firstNameFocusNode,
        lastNameFocusNode: lastNameFocusNode ?? this.lastNameFocusNode,
        emailFocusNode: emailFocusNode ?? this.emailFocusNode,
        passwordFocusNode: passwordFocusNode ?? this.passwordFocusNode,
        confirmPasswordFocusNode:
            confirmPasswordFocusNode ?? this.confirmPasswordFocusNode,
        failure: failure ?? this.failure,
        pageController: pageController ?? this.pageController,
        loadGyms: loadGyms ?? this.loadGyms,
        pageScrollLimit: pageScrollLimit ?? this.pageScrollLimit,
      );

  @override
  List<Object> get props => [
        ...super.props,
        failure,
      ];
}

class ProfilePictureUploaded extends GymsLoaded {
  final XFile profilePicture;

  const ProfilePictureUploaded({
    required super.autovalidateMode,
    required super.confirmPasswordController,
    required super.emailController,
    required super.firstNameController,
    required super.lastNameController,
    required super.passwordController,
    required super.pageIndex,
    required super.pageOneFormKey,
    required super.pageTwoFormKey,
    required super.firstNameFocusNode,
    required super.lastNameFocusNode,
    required super.emailFocusNode,
    required super.passwordFocusNode,
    required super.confirmPasswordFocusNode,
    required super.pageController,
    required super.loadGyms,
    required super.gyms,
    required super.gym,
    required super.showMustSelectGymError,
    required super.location,
    required super.pageScrollLimit,
    required super.cameraController,
    required this.profilePicture,
  }) : super();

  @override
  List<Object> get props => [
        ...super.props,
        profilePicture,
      ];
}
