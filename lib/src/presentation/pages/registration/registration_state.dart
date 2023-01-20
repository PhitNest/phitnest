// import 'package:async/async.dart';
// import 'package:camera/camera.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter/material.dart';

// import '../../../common/failure.dart';
// import '../../../data/data_sources/backend/backend.dart';
// import '../../../domain/entities/entities.dart';
// import '../bloc_state.dart';

// abstract class RegistrationState extends BlocState {
//   const RegistrationState() : super();
// }

// class RegistrationInitial extends RegistrationState {
//   final TextEditingController firstNameController;
//   final TextEditingController lastNameController;
//   final TextEditingController emailController;
//   final TextEditingController passwordController;
//   final TextEditingController confirmPasswordController;
//   final PageController pageController;
//   final GlobalKey<FormState> pageOneFormKey;
//   final GlobalKey<FormState> pageTwoFormKey;
//   final AutovalidateMode autovalidateMode;
//   final FocusNode firstNameFocusNode;
//   final FocusNode lastNameFocusNode;
//   final FocusNode emailFocusNode;
//   final FocusNode passwordFocusNode;
//   final FocusNode confirmPasswordFocusNode;
//   final int pageIndex;
//   final int pageScrollLimit;
//   final CancelableOperation<
//       Either<Tuple2<List<GymEntity>, LocationEntity>, Failure>> loadGyms;

//   const RegistrationInitial({
//     required this.firstNameController,
//     required this.lastNameController,
//     required this.emailController,
//     required this.passwordController,
//     required this.confirmPasswordController,
//     required this.pageController,
//     required this.pageOneFormKey,
//     required this.pageTwoFormKey,
//     required this.autovalidateMode,
//     required this.pageIndex,
//     required this.firstNameFocusNode,
//     required this.lastNameFocusNode,
//     required this.emailFocusNode,
//     required this.passwordFocusNode,
//     required this.confirmPasswordFocusNode,
//     required this.loadGyms,
//     required this.pageScrollLimit,
//   }) : super();

//   @override
//   List<Object> get props => [
//         firstNameController,
//         lastNameController,
//         emailController,
//         passwordController,
//         confirmPasswordController,
//         pageController,
//         pageOneFormKey,
//         pageTwoFormKey,
//         autovalidateMode,
//         pageIndex,
//         firstNameFocusNode,
//         lastNameFocusNode,
//         emailFocusNode,
//         passwordFocusNode,
//         confirmPasswordFocusNode,
//         loadGyms,
//         pageScrollLimit,
//       ];

//   @override
//   Future<void> dispose() async {
//     firstNameController.dispose();
//     lastNameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     firstNameFocusNode.dispose();
//     lastNameFocusNode.dispose();
//     emailFocusNode.dispose();
//     passwordFocusNode.dispose();
//     confirmPasswordFocusNode.dispose();
//     pageController.dispose();
//     await loadGyms.cancel();
//     return super.dispose();
//   }
// }

// class GymsLoaded extends RegistrationInitial {
//   final List<GymEntity> gyms;
//   final GymEntity? gym;
//   final LocationEntity location;
//   final bool showMustSelectGymError;
//   final CameraController cameraController;
//   final Set<String> takenEmails;

//   const GymsLoaded({
//     required super.autovalidateMode,
//     required super.confirmPasswordController,
//     required super.emailController,
//     required super.firstNameController,
//     required super.lastNameController,
//     required super.passwordController,
//     required super.pageIndex,
//     required super.pageOneFormKey,
//     required super.pageTwoFormKey,
//     required super.firstNameFocusNode,
//     required super.lastNameFocusNode,
//     required super.emailFocusNode,
//     required super.passwordFocusNode,
//     required super.confirmPasswordFocusNode,
//     required super.pageController,
//     required super.loadGyms,
//     required super.pageScrollLimit,
//     required this.showMustSelectGymError,
//     required this.gyms,
//     required this.location,
//     required this.cameraController,
//     required this.gym,
//     required this.takenEmails,
//   }) : super();

//   GymsLoaded copyWith({
//     TextEditingController? firstNameController,
//     TextEditingController? lastNameController,
//     TextEditingController? emailController,
//     TextEditingController? passwordController,
//     TextEditingController? confirmPasswordController,
//     AutovalidateMode? autovalidateMode,
//     int? pageIndex,
//     GlobalKey<FormState>? pageOneFormKey,
//     GlobalKey<FormState>? pageTwoFormKey,
//     FocusNode? firstNameFocusNode,
//     FocusNode? lastNameFocusNode,
//     FocusNode? emailFocusNode,
//     FocusNode? passwordFocusNode,
//     FocusNode? confirmPasswordFocusNode,
//     PageController? pageController,
//     CancelableOperation<
//             Either<Tuple2<List<GymEntity>, LocationEntity>, Failure>>?
//         loadGyms,
//     bool? showMustSelectGymError,
//     List<GymEntity>? gyms,
//     GymEntity? gym,
//     LocationEntity? location,
//     int? pageScrollLimit,
//     CameraController? cameraController,
//     Set<String>? takenEmails,
//   }) =>
//       GymsLoaded(
//         firstNameController: firstNameController ?? this.firstNameController,
//         lastNameController: lastNameController ?? this.lastNameController,
//         emailController: emailController ?? this.emailController,
//         passwordController: passwordController ?? this.passwordController,
//         confirmPasswordController:
//             confirmPasswordController ?? this.confirmPasswordController,
//         autovalidateMode: autovalidateMode ?? this.autovalidateMode,
//         pageIndex: pageIndex ?? this.pageIndex,
//         pageOneFormKey: pageOneFormKey ?? this.pageOneFormKey,
//         pageTwoFormKey: pageTwoFormKey ?? this.pageTwoFormKey,
//         firstNameFocusNode: firstNameFocusNode ?? this.firstNameFocusNode,
//         lastNameFocusNode: lastNameFocusNode ?? this.lastNameFocusNode,
//         emailFocusNode: emailFocusNode ?? this.emailFocusNode,
//         passwordFocusNode: passwordFocusNode ?? this.passwordFocusNode,
//         confirmPasswordFocusNode:
//             confirmPasswordFocusNode ?? this.confirmPasswordFocusNode,
//         gyms: gyms ?? this.gyms,
//         pageController: pageController ?? this.pageController,
//         loadGyms: loadGyms ?? this.loadGyms,
//         gym: gym ?? this.gym,
//         showMustSelectGymError:
//             showMustSelectGymError ?? this.showMustSelectGymError,
//         location: location ?? this.location,
//         pageScrollLimit: pageScrollLimit ?? this.pageScrollLimit,
//         cameraController: cameraController ?? this.cameraController,
//         takenEmails: takenEmails ?? this.takenEmails,
//       );

//   @override
//   List<Object> get props => [
//         ...super.props,
//         gyms,
//         showMustSelectGymError,
//         location,
//         cameraController,
//         takenEmails,
//         ...(gym != null ? [gym!] : []),
//       ];

//   @override
//   Future<void> dispose() async {
//     await cameraController.dispose();
//     return super.dispose();
//   }
// }

// class GymsLoadingError extends RegistrationInitial {
//   final Failure failure;

//   const GymsLoadingError({
//     required super.autovalidateMode,
//     required super.confirmPasswordController,
//     required super.emailController,
//     required super.firstNameController,
//     required super.lastNameController,
//     required super.passwordController,
//     required super.pageIndex,
//     required super.pageOneFormKey,
//     required super.pageTwoFormKey,
//     required super.firstNameFocusNode,
//     required super.lastNameFocusNode,
//     required super.emailFocusNode,
//     required super.passwordFocusNode,
//     required super.confirmPasswordFocusNode,
//     required super.pageController,
//     required super.loadGyms,
//     required super.pageScrollLimit,
//     required this.failure,
//   }) : super();

//   GymsLoadingError copyWith({
//     TextEditingController? firstNameController,
//     TextEditingController? lastNameController,
//     TextEditingController? emailController,
//     TextEditingController? passwordController,
//     TextEditingController? confirmPasswordController,
//     AutovalidateMode? autovalidateMode,
//     int? pageIndex,
//     GlobalKey<FormState>? pageOneFormKey,
//     GlobalKey<FormState>? pageTwoFormKey,
//     FocusNode? firstNameFocusNode,
//     FocusNode? lastNameFocusNode,
//     FocusNode? emailFocusNode,
//     FocusNode? passwordFocusNode,
//     FocusNode? confirmPasswordFocusNode,
//     PageController? pageController,
//     CancelableOperation<
//             Either<Tuple2<List<GymEntity>, LocationEntity>, Failure>>?
//         loadGyms,
//     Failure? failure,
//     int? pageScrollLimit,
//   }) =>
//       GymsLoadingError(
//         firstNameController: firstNameController ?? this.firstNameController,
//         lastNameController: lastNameController ?? this.lastNameController,
//         emailController: emailController ?? this.emailController,
//         passwordController: passwordController ?? this.passwordController,
//         confirmPasswordController:
//             confirmPasswordController ?? this.confirmPasswordController,
//         autovalidateMode: autovalidateMode ?? this.autovalidateMode,
//         pageIndex: pageIndex ?? this.pageIndex,
//         pageOneFormKey: pageOneFormKey ?? this.pageOneFormKey,
//         pageTwoFormKey: pageTwoFormKey ?? this.pageTwoFormKey,
//         firstNameFocusNode: firstNameFocusNode ?? this.firstNameFocusNode,
//         lastNameFocusNode: lastNameFocusNode ?? this.lastNameFocusNode,
//         emailFocusNode: emailFocusNode ?? this.emailFocusNode,
//         passwordFocusNode: passwordFocusNode ?? this.passwordFocusNode,
//         confirmPasswordFocusNode:
//             confirmPasswordFocusNode ?? this.confirmPasswordFocusNode,
//         failure: failure ?? this.failure,
//         pageController: pageController ?? this.pageController,
//         loadGyms: loadGyms ?? this.loadGyms,
//         pageScrollLimit: pageScrollLimit ?? this.pageScrollLimit,
//       );

//   @override
//   List<Object> get props => [
//         ...super.props,
//         failure,
//       ];
// }

// class UploadPictureLoading extends GymsLoaded {
//   const UploadPictureLoading({
//     required super.autovalidateMode,
//     required super.confirmPasswordController,
//     required super.emailController,
//     required super.firstNameController,
//     required super.lastNameController,
//     required super.passwordController,
//     required super.pageIndex,
//     required super.pageOneFormKey,
//     required super.pageTwoFormKey,
//     required super.firstNameFocusNode,
//     required super.lastNameFocusNode,
//     required super.emailFocusNode,
//     required super.passwordFocusNode,
//     required super.confirmPasswordFocusNode,
//     required super.pageController,
//     required super.loadGyms,
//     required super.gyms,
//     required super.gym,
//     required super.showMustSelectGymError,
//     required super.location,
//     required super.pageScrollLimit,
//     required super.cameraController,
//     required super.takenEmails,
//   }) : super();

//   UploadPictureLoading copyWith({
//     TextEditingController? firstNameController,
//     TextEditingController? lastNameController,
//     TextEditingController? emailController,
//     TextEditingController? passwordController,
//     TextEditingController? confirmPasswordController,
//     AutovalidateMode? autovalidateMode,
//     int? pageIndex,
//     GlobalKey<FormState>? pageOneFormKey,
//     GlobalKey<FormState>? pageTwoFormKey,
//     FocusNode? firstNameFocusNode,
//     FocusNode? lastNameFocusNode,
//     FocusNode? emailFocusNode,
//     FocusNode? passwordFocusNode,
//     FocusNode? confirmPasswordFocusNode,
//     PageController? pageController,
//     CancelableOperation<
//             Either<Tuple2<List<GymEntity>, LocationEntity>, Failure>>?
//         loadGyms,
//     List<GymEntity>? gyms,
//     GymEntity? gym,
//     bool? showMustSelectGymError,
//     LocationEntity? location,
//     int? pageScrollLimit,
//     CameraController? cameraController,
//     Set<String>? takenEmails,
//   }) =>
//       UploadPictureLoading(
//         firstNameController: firstNameController ?? this.firstNameController,
//         lastNameController: lastNameController ?? this.lastNameController,
//         emailController: emailController ?? this.emailController,
//         passwordController: passwordController ?? this.passwordController,
//         confirmPasswordController:
//             confirmPasswordController ?? this.confirmPasswordController,
//         autovalidateMode: autovalidateMode ?? this.autovalidateMode,
//         pageIndex: pageIndex ?? this.pageIndex,
//         pageOneFormKey: pageOneFormKey ?? this.pageOneFormKey,
//         pageTwoFormKey: pageTwoFormKey ?? this.pageTwoFormKey,
//         firstNameFocusNode: firstNameFocusNode ?? this.firstNameFocusNode,
//         lastNameFocusNode: lastNameFocusNode ?? this.lastNameFocusNode,
//         emailFocusNode: emailFocusNode ?? this.emailFocusNode,
//         passwordFocusNode: passwordFocusNode ?? this.passwordFocusNode,
//         confirmPasswordFocusNode:
//             confirmPasswordFocusNode ?? this.confirmPasswordFocusNode,
//         pageController: pageController ?? this.pageController,
//         loadGyms: loadGyms ?? this.loadGyms,
//         gyms: gyms ?? this.gyms,
//         gym: gym ?? this.gym,
//         showMustSelectGymError:
//             showMustSelectGymError ?? this.showMustSelectGymError,
//         location: location ?? this.location,
//         pageScrollLimit: pageScrollLimit ?? this.pageScrollLimit,
//         cameraController: cameraController ?? this.cameraController,
//         takenEmails: takenEmails ?? this.takenEmails,
//       );
// }

// class ProfilePictureUploaded extends GymsLoaded {
//   final XFile profilePicture;

//   const ProfilePictureUploaded({
//     required super.autovalidateMode,
//     required super.confirmPasswordController,
//     required super.emailController,
//     required super.firstNameController,
//     required super.lastNameController,
//     required super.passwordController,
//     required super.pageIndex,
//     required super.pageOneFormKey,
//     required super.pageTwoFormKey,
//     required super.firstNameFocusNode,
//     required super.lastNameFocusNode,
//     required super.emailFocusNode,
//     required super.passwordFocusNode,
//     required super.confirmPasswordFocusNode,
//     required super.pageController,
//     required super.loadGyms,
//     required super.gyms,
//     required super.gym,
//     required super.showMustSelectGymError,
//     required super.location,
//     required super.pageScrollLimit,
//     required super.cameraController,
//     required super.takenEmails,
//     required this.profilePicture,
//   }) : super();

//   ProfilePictureUploaded copyWith({
//     TextEditingController? firstNameController,
//     TextEditingController? lastNameController,
//     TextEditingController? emailController,
//     TextEditingController? passwordController,
//     TextEditingController? confirmPasswordController,
//     AutovalidateMode? autovalidateMode,
//     int? pageIndex,
//     GlobalKey<FormState>? pageOneFormKey,
//     GlobalKey<FormState>? pageTwoFormKey,
//     FocusNode? firstNameFocusNode,
//     FocusNode? lastNameFocusNode,
//     FocusNode? emailFocusNode,
//     FocusNode? passwordFocusNode,
//     FocusNode? confirmPasswordFocusNode,
//     PageController? pageController,
//     CancelableOperation<
//             Either<Tuple2<List<GymEntity>, LocationEntity>, Failure>>?
//         loadGyms,
//     bool? showMustSelectGymError,
//     List<GymEntity>? gyms,
//     GymEntity? gym,
//     LocationEntity? location,
//     int? pageScrollLimit,
//     CameraController? cameraController,
//     XFile? profilePicture,
//     Set<String>? takenEmails,
//   }) =>
//       ProfilePictureUploaded(
//         firstNameController: firstNameController ?? this.firstNameController,
//         lastNameController: lastNameController ?? this.lastNameController,
//         emailController: emailController ?? this.emailController,
//         passwordController: passwordController ?? this.passwordController,
//         confirmPasswordController:
//             confirmPasswordController ?? this.confirmPasswordController,
//         autovalidateMode: autovalidateMode ?? this.autovalidateMode,
//         pageIndex: pageIndex ?? this.pageIndex,
//         pageOneFormKey: pageOneFormKey ?? this.pageOneFormKey,
//         pageTwoFormKey: pageTwoFormKey ?? this.pageTwoFormKey,
//         firstNameFocusNode: firstNameFocusNode ?? this.firstNameFocusNode,
//         lastNameFocusNode: lastNameFocusNode ?? this.lastNameFocusNode,
//         emailFocusNode: emailFocusNode ?? this.emailFocusNode,
//         passwordFocusNode: passwordFocusNode ?? this.passwordFocusNode,
//         confirmPasswordFocusNode:
//             confirmPasswordFocusNode ?? this.confirmPasswordFocusNode,
//         pageController: pageController ?? this.pageController,
//         loadGyms: loadGyms ?? this.loadGyms,
//         gyms: gyms ?? this.gyms,
//         gym: gym ?? this.gym,
//         showMustSelectGymError:
//             showMustSelectGymError ?? this.showMustSelectGymError,
//         location: location ?? this.location,
//         pageScrollLimit: pageScrollLimit ?? this.pageScrollLimit,
//         cameraController: cameraController ?? this.cameraController,
//         profilePicture: profilePicture ?? this.profilePicture,
//         takenEmails: takenEmails ?? this.takenEmails,
//       );

//   @override
//   List<Object> get props => [
//         ...super.props,
//         profilePicture,
//       ];
// }

// class RegistrationLoading extends ProfilePictureUploaded {
//   final CancelableOperation<Either<RegisterResponse, Failure>> registerOp;

//   const RegistrationLoading({
//     required super.autovalidateMode,
//     required super.confirmPasswordController,
//     required super.emailController,
//     required super.firstNameController,
//     required super.lastNameController,
//     required super.passwordController,
//     required super.pageIndex,
//     required super.pageOneFormKey,
//     required super.pageTwoFormKey,
//     required super.firstNameFocusNode,
//     required super.lastNameFocusNode,
//     required super.emailFocusNode,
//     required super.passwordFocusNode,
//     required super.confirmPasswordFocusNode,
//     required super.pageController,
//     required super.loadGyms,
//     required super.gyms,
//     required super.gym,
//     required super.showMustSelectGymError,
//     required super.location,
//     required super.pageScrollLimit,
//     required super.cameraController,
//     required super.profilePicture,
//     required super.takenEmails,
//     required this.registerOp,
//   }) : super();

//   RegistrationLoading copyWith({
//     TextEditingController? firstNameController,
//     TextEditingController? lastNameController,
//     TextEditingController? emailController,
//     TextEditingController? passwordController,
//     TextEditingController? confirmPasswordController,
//     AutovalidateMode? autovalidateMode,
//     int? pageIndex,
//     GlobalKey<FormState>? pageOneFormKey,
//     GlobalKey<FormState>? pageTwoFormKey,
//     FocusNode? firstNameFocusNode,
//     FocusNode? lastNameFocusNode,
//     FocusNode? emailFocusNode,
//     FocusNode? passwordFocusNode,
//     FocusNode? confirmPasswordFocusNode,
//     PageController? pageController,
//     CancelableOperation<
//             Either<Tuple2<List<GymEntity>, LocationEntity>, Failure>>?
//         loadGyms,
//     bool? showMustSelectGymError,
//     List<GymEntity>? gyms,
//     GymEntity? gym,
//     LocationEntity? location,
//     int? pageScrollLimit,
//     CameraController? cameraController,
//     XFile? profilePicture,
//     CancelableOperation<Either<RegisterResponse, Failure>>? registerOp,
//     Set<String>? takenEmails,
//   }) =>
//       RegistrationLoading(
//         firstNameController: firstNameController ?? this.firstNameController,
//         lastNameController: lastNameController ?? this.lastNameController,
//         emailController: emailController ?? this.emailController,
//         passwordController: passwordController ?? this.passwordController,
//         confirmPasswordController:
//             confirmPasswordController ?? this.confirmPasswordController,
//         autovalidateMode: autovalidateMode ?? this.autovalidateMode,
//         pageIndex: pageIndex ?? this.pageIndex,
//         pageOneFormKey: pageOneFormKey ?? this.pageOneFormKey,
//         pageTwoFormKey: pageTwoFormKey ?? this.pageTwoFormKey,
//         firstNameFocusNode: firstNameFocusNode ?? this.firstNameFocusNode,
//         lastNameFocusNode: lastNameFocusNode ?? this.lastNameFocusNode,
//         emailFocusNode: emailFocusNode ?? this.emailFocusNode,
//         passwordFocusNode: passwordFocusNode ?? this.passwordFocusNode,
//         confirmPasswordFocusNode:
//             confirmPasswordFocusNode ?? this.confirmPasswordFocusNode,
//         pageController: pageController ?? this.pageController,
//         loadGyms: loadGyms ?? this.loadGyms,
//         gyms: gyms ?? this.gyms,
//         gym: gym ?? this.gym,
//         showMustSelectGymError:
//             showMustSelectGymError ?? this.showMustSelectGymError,
//         location: location ?? this.location,
//         pageScrollLimit: pageScrollLimit ?? this.pageScrollLimit,
//         cameraController: cameraController ?? this.cameraController,
//         profilePicture: profilePicture ?? this.profilePicture,
//         registerOp: registerOp ?? this.registerOp,
//         takenEmails: takenEmails ?? this.takenEmails,
//       );

//   @override
//   List<Object> get props => [
//         ...super.props,
//         registerOp,
//       ];

//   @override
//   Future<void> dispose() async {
//     await registerOp.cancel();
//     return super.dispose();
//   }
// }

// class RegistrationRequestErrorState extends ProfilePictureUploaded {
//   final Failure failure;

//   const RegistrationRequestErrorState({
//     required super.autovalidateMode,
//     required super.confirmPasswordController,
//     required super.emailController,
//     required super.firstNameController,
//     required super.lastNameController,
//     required super.passwordController,
//     required super.pageIndex,
//     required super.pageOneFormKey,
//     required super.pageTwoFormKey,
//     required super.firstNameFocusNode,
//     required super.lastNameFocusNode,
//     required super.emailFocusNode,
//     required super.passwordFocusNode,
//     required super.confirmPasswordFocusNode,
//     required super.pageController,
//     required super.loadGyms,
//     required super.gyms,
//     required super.gym,
//     required super.showMustSelectGymError,
//     required super.location,
//     required super.pageScrollLimit,
//     required super.cameraController,
//     required super.profilePicture,
//     required super.takenEmails,
//     required this.failure,
//   }) : super();

//   RegistrationRequestErrorState copyWith({
//     TextEditingController? firstNameController,
//     TextEditingController? lastNameController,
//     TextEditingController? emailController,
//     TextEditingController? passwordController,
//     TextEditingController? confirmPasswordController,
//     AutovalidateMode? autovalidateMode,
//     int? pageIndex,
//     GlobalKey<FormState>? pageOneFormKey,
//     GlobalKey<FormState>? pageTwoFormKey,
//     FocusNode? firstNameFocusNode,
//     FocusNode? lastNameFocusNode,
//     FocusNode? emailFocusNode,
//     FocusNode? passwordFocusNode,
//     FocusNode? confirmPasswordFocusNode,
//     PageController? pageController,
//     CancelableOperation<
//             Either<Tuple2<List<GymEntity>, LocationEntity>, Failure>>?
//         loadGyms,
//     bool? showMustSelectGymError,
//     List<GymEntity>? gyms,
//     GymEntity? gym,
//     LocationEntity? location,
//     int? pageScrollLimit,
//     CameraController? cameraController,
//     XFile? profilePicture,
//     Failure? failure,
//     Set<String>? takenEmails,
//   }) =>
//       RegistrationRequestErrorState(
//         firstNameController: firstNameController ?? this.firstNameController,
//         lastNameController: lastNameController ?? this.lastNameController,
//         emailController: emailController ?? this.emailController,
//         passwordController: passwordController ?? this.passwordController,
//         confirmPasswordController:
//             confirmPasswordController ?? this.confirmPasswordController,
//         autovalidateMode: autovalidateMode ?? this.autovalidateMode,
//         pageIndex: pageIndex ?? this.pageIndex,
//         pageOneFormKey: pageOneFormKey ?? this.pageOneFormKey,
//         pageTwoFormKey: pageTwoFormKey ?? this.pageTwoFormKey,
//         firstNameFocusNode: firstNameFocusNode ?? this.firstNameFocusNode,
//         lastNameFocusNode: lastNameFocusNode ?? this.lastNameFocusNode,
//         emailFocusNode: emailFocusNode ?? this.emailFocusNode,
//         passwordFocusNode: passwordFocusNode ?? this.passwordFocusNode,
//         confirmPasswordFocusNode:
//             confirmPasswordFocusNode ?? this.confirmPasswordFocusNode,
//         pageController: pageController ?? this.pageController,
//         loadGyms: loadGyms ?? this.loadGyms,
//         gyms: gyms ?? this.gyms,
//         gym: gym ?? this.gym,
//         showMustSelectGymError:
//             showMustSelectGymError ?? this.showMustSelectGymError,
//         location: location ?? this.location,
//         pageScrollLimit: pageScrollLimit ?? this.pageScrollLimit,
//         cameraController: cameraController ?? this.cameraController,
//         profilePicture: profilePicture ?? this.profilePicture,
//         failure: failure ?? this.failure,
//         takenEmails: takenEmails ?? this.takenEmails,
//       );

//   @override
//   List<Object> get props => [
//         ...super.props,
//         failure,
//       ];
// }

// class RegistrationSuccessState extends RegistrationState {
//   final UserEntity user;

//   const RegistrationSuccessState({
//     required super.autovalidateMode,
//     required super.confirmPasswordController,
//     required super.emailController,
//     required super.firstNameController,
//     required super.lastNameController,
//     required super.passwordController,
//     required super.pageIndex,
//     required super.pageOneFormKey,
//     required super.pageTwoFormKey,
//     required super.firstNameFocusNode,
//     required super.lastNameFocusNode,
//     required super.emailFocusNode,
//     required super.passwordFocusNode,
//     required super.confirmPasswordFocusNode,
//     required super.pageController,
//     required super.loadGyms,
//     required super.pageScrollLimit,
//     required this.user,
//   }) : super();

//   List<Object> get props => [
//         ...super.props,
//         user,
//       ];
// }

// class S3RequestLoadingState extends ProfilePictureUploaded {
//   final UserEntity user;
//   final CancelableOperation<Failure?> s3RequestOp;

//   const S3RequestLoadingState({
//     required super.autovalidateMode,
//     required super.confirmPasswordController,
//     required super.emailController,
//     required super.firstNameController,
//     required super.lastNameController,
//     required super.passwordController,
//     required super.pageIndex,
//     required super.pageOneFormKey,
//     required super.pageTwoFormKey,
//     required super.firstNameFocusNode,
//     required super.lastNameFocusNode,
//     required super.emailFocusNode,
//     required super.passwordFocusNode,
//     required super.confirmPasswordFocusNode,
//     required super.pageController,
//     required super.loadGyms,
//     required super.gyms,
//     required super.gym,
//     required super.showMustSelectGymError,
//     required super.location,
//     required super.pageScrollLimit,
//     required super.cameraController,
//     required super.profilePicture,
//     required super.takenEmails,
//     required this.user,
//     required this.s3RequestOp,
//   }) : super();

//   S3RequestLoadingState copyWith({
//     TextEditingController? firstNameController,
//     TextEditingController? lastNameController,
//     TextEditingController? emailController,
//     TextEditingController? passwordController,
//     TextEditingController? confirmPasswordController,
//     AutovalidateMode? autovalidateMode,
//     int? pageIndex,
//     GlobalKey<FormState>? pageOneFormKey,
//     GlobalKey<FormState>? pageTwoFormKey,
//     FocusNode? firstNameFocusNode,
//     FocusNode? lastNameFocusNode,
//     FocusNode? emailFocusNode,
//     FocusNode? passwordFocusNode,
//     FocusNode? confirmPasswordFocusNode,
//     PageController? pageController,
//     CancelableOperation<
//             Either<Tuple2<List<GymEntity>, LocationEntity>, Failure>>?
//         loadGyms,
//     bool? showMustSelectGymError,
//     List<GymEntity>? gyms,
//     GymEntity? gym,
//     LocationEntity? location,
//     int? pageScrollLimit,
//     CameraController? cameraController,
//     XFile? profilePicture,
//     Set<String>? takenEmails,
//     UserEntity? user,
//     CancelableOperation<Failure?>? s3RequestOp,
//   }) =>
//       S3RequestLoadingState(
//         firstNameController: firstNameController ?? this.firstNameController,
//         lastNameController: lastNameController ?? this.lastNameController,
//         emailController: emailController ?? this.emailController,
//         passwordController: passwordController ?? this.passwordController,
//         confirmPasswordController:
//             confirmPasswordController ?? this.confirmPasswordController,
//         autovalidateMode: autovalidateMode ?? this.autovalidateMode,
//         pageIndex: pageIndex ?? this.pageIndex,
//         pageOneFormKey: pageOneFormKey ?? this.pageOneFormKey,
//         pageTwoFormKey: pageTwoFormKey ?? this.pageTwoFormKey,
//         firstNameFocusNode: firstNameFocusNode ?? this.firstNameFocusNode,
//         lastNameFocusNode: lastNameFocusNode ?? this.lastNameFocusNode,
//         emailFocusNode: emailFocusNode ?? this.emailFocusNode,
//         passwordFocusNode: passwordFocusNode ?? this.passwordFocusNode,
//         confirmPasswordFocusNode:
//             confirmPasswordFocusNode ?? this.confirmPasswordFocusNode,
//         pageController: pageController ?? this.pageController,
//         loadGyms: loadGyms ?? this.loadGyms,
//         gyms: gyms ?? this.gyms,
//         gym: gym ?? this.gym,
//         showMustSelectGymError:
//             showMustSelectGymError ?? this.showMustSelectGymError,
//         location: location ?? this.location,
//         pageScrollLimit: pageScrollLimit ?? this.pageScrollLimit,
//         cameraController: cameraController ?? this.cameraController,
//         profilePicture: profilePicture ?? this.profilePicture,
//         takenEmails: takenEmails ?? this.takenEmails,
//         user: user ?? this.user,
//         s3RequestOp: s3RequestOp ?? this.s3RequestOp,
//       );

//   @override
//   List<Object> get props => [
//         ...super.props,
//         user,
//         s3RequestOp,
//       ];
// }

// class S3RequestErrorState extends ProfilePictureUploaded {
//   final Failure failure;

//   const S3RequestErrorState({
//     required super.autovalidateMode,
//     required super.confirmPasswordController,
//     required super.emailController,
//     required super.firstNameController,
//     required super.lastNameController,
//     required super.passwordController,
//     required super.pageIndex,
//     required super.pageOneFormKey,
//     required super.pageTwoFormKey,
//     required super.firstNameFocusNode,
//     required super.lastNameFocusNode,
//     required super.emailFocusNode,
//     required super.passwordFocusNode,
//     required super.confirmPasswordFocusNode,
//     required super.pageController,
//     required super.loadGyms,
//     required super.gyms,
//     required super.gym,
//     required super.showMustSelectGymError,
//     required super.location,
//     required super.pageScrollLimit,
//     required super.cameraController,
//     required super.profilePicture,
//     required super.takenEmails,
//     required this.failure,
//   }) : super();

//   S3RequestErrorState copyWith({
//     TextEditingController? firstNameController,
//     TextEditingController? lastNameController,
//     TextEditingController? emailController,
//     TextEditingController? passwordController,
//     TextEditingController? confirmPasswordController,
//     AutovalidateMode? autovalidateMode,
//     int? pageIndex,
//     GlobalKey<FormState>? pageOneFormKey,
//     GlobalKey<FormState>? pageTwoFormKey,
//     FocusNode? firstNameFocusNode,
//     FocusNode? lastNameFocusNode,
//     FocusNode? emailFocusNode,
//     FocusNode? passwordFocusNode,
//     FocusNode? confirmPasswordFocusNode,
//     PageController? pageController,
//     CancelableOperation<
//             Either<Tuple2<List<GymEntity>, LocationEntity>, Failure>>?
//         loadGyms,
//     bool? showMustSelectGymError,
//     List<GymEntity>? gyms,
//     GymEntity? gym,
//     LocationEntity? location,
//     int? pageScrollLimit,
//     CameraController? cameraController,
//     XFile? profilePicture,
//     Set<String>? takenEmails,
//     Failure? failure,
//   }) =>
//       S3RequestErrorState(
//         firstNameController: firstNameController ?? this.firstNameController,
//         lastNameController: lastNameController ?? this.lastNameController,
//         emailController: emailController ?? this.emailController,
//         passwordController: passwordController ?? this.passwordController,
//         confirmPasswordController:
//             confirmPasswordController ?? this.confirmPasswordController,
//         autovalidateMode: autovalidateMode ?? this.autovalidateMode,
//         pageIndex: pageIndex ?? this.pageIndex,
//         pageOneFormKey: pageOneFormKey ?? this.pageOneFormKey,
//         pageTwoFormKey: pageTwoFormKey ?? this.pageTwoFormKey,
//         firstNameFocusNode: firstNameFocusNode ?? this.firstNameFocusNode,
//         lastNameFocusNode: lastNameFocusNode ?? this.lastNameFocusNode,
//         emailFocusNode: emailFocusNode ?? this.emailFocusNode,
//         passwordFocusNode: passwordFocusNode ?? this.passwordFocusNode,
//         confirmPasswordFocusNode:
//             confirmPasswordFocusNode ?? this.confirmPasswordFocusNode,
//         pageController: pageController ?? this.pageController,
//         loadGyms: loadGyms ?? this.loadGyms,
//         gyms: gyms ?? this.gyms,
//         gym: gym ?? this.gym,
//         showMustSelectGymError:
//             showMustSelectGymError ?? this.showMustSelectGymError,
//         location: location ?? this.location,
//         pageScrollLimit: pageScrollLimit ?? this.pageScrollLimit,
//         cameraController: cameraController ?? this.cameraController,
//         profilePicture: profilePicture ?? this.profilePicture,
//         takenEmails: takenEmails ?? this.takenEmails,
//         failure: failure ?? this.failure,
//       );

//   @override
//   List<Object> get props => [
//         ...super.props,
//         failure,
//       ];
// }
