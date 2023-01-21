import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/use_cases/use_cases.dart';
import '../event/registration_event.dart';
import '../state/registration_state.dart';
import 'on_capture_photo.dart';
import 'on_confirm_gym.dart';
import 'on_edit_first_name.dart';
import 'on_gym_loading_error.dart';
import 'on_gym_selected.dart';
import 'on_gyms_loaded.dart';
import 'on_read_photo_instructions.dart';
import 'on_register.dart';
import 'on_register_error.dart';
import 'on_register_success.dart';
import 'on_retake_photo.dart';
import 'on_retry_camera_init.dart';
import 'on_retry_load_gyms.dart';
import 'on_retry_photo_upload.dart';
import 'on_set_profile_picture.dart';
import 'on_submit_page_two.dart';
import 'on_upload_error.dart';
import 'on_submit_page_one.dart';
import 'on_swipe.dart';
import 'on_upload_success.dart';

const pageAnimation = const Duration(milliseconds: 400);

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc()
      : super(
          GymsLoadingState(
            firstNameController: TextEditingController(),
            firstNameFocusNode: FocusNode(),
            lastNameController: TextEditingController(),
            lastNameFocusNode: FocusNode(),
            emailController: TextEditingController(),
            emailFocusNode: FocusNode(),
            passwordController: TextEditingController(),
            passwordFocusNode: FocusNode(),
            confirmPasswordController: TextEditingController(),
            confirmPasswordFocusNode: FocusNode(),
            pageController: PageController(),
            pageOneFormKey: GlobalKey<FormState>(),
            pageTwoFormKey: GlobalKey<FormState>(),
            firstNameConfirmed: false,
            loadGymsOp: CancelableOperation.fromFuture(loadGyms()),
            currentPage: 0,
            autovalidateMode: AutovalidateMode.disabled,
          ),
        ) {
    (state as GymsLoadingState).loadGymsOp.then(
          (either) => either.fold(
            (success) => add(GymsLoadedEvent(success.value1, success.value2)),
            (failure) => add(GymsLoadingErrorEvent(failure)),
          ),
        );
    on<RetryLoadGymsEvent>(
        (event, emit) => onRetryLoadGyms(event, emit, state, add));
    on<EditFirstNameEvent>(
        (event, emit) => onEditFirstName(event, emit, state));
    on<GymsLoadedEvent>((event, emit) => onGymsLoaded(event, emit, state));
    on<GymsLoadingErrorEvent>(
        (event, emit) => onGymsLoadingError(event, emit, state));
    on<GymSelectedEvent>((event, emit) => onGymSelected(event, emit, state));
    on<ConfirmGymEvent>((event, emit) => onGymConfirmed(event, emit, state));
    on<SwipeEvent>((event, emit) => onSwipe(event, emit, state));
    on<SubmitPageOneEvent>(
        (event, emit) => onSubmitPageOne(event, emit, state));
    on<SubmitPageTwoEvent>(
        (event, emit) => onSubmitPageTwo(event, emit, state));
    on<ReadPhotoInstructionsEvent>(
        (event, emit) => onReadPhotoInstructions(event, emit, state));
    on<RetryCameraInitializationEvent>(
        (event, emit) => onRetryCameraInit(event, emit, state));
    on<CapturePhotoEvent>(
      (event, emit) => onCapturePhoto(event, emit, state, add),
    );
    on<SetProfilePictureEvent>(
        (event, emit) => onSetProfilePicture(event, emit, state));
    on<RetakeProfilePictureEvent>(
        (event, emit) => onRetakeProfilePicture(event, emit, state));
    on<RegisterEvent>((event, emit) => onRegister(
          event,
          emit,
          state,
          add,
        ));
    on<RegisterErrorEvent>((event, emit) => onRegisterError(
          event,
          emit,
          state,
          add,
        ));
    on<RegisterSuccessEvent>((event, emit) => onRegisterSuccess(
          event,
          emit,
          state,
          add,
        ));
    on<UploadErrorEvent>((event, emit) => onUploadError(event, emit, state));
    on<UploadSuccessEvent>(
        (event, emit) => onUploadSuccess(event, emit, state));
    on<RetryPhotoUploadEvent>(
        (event, emit) => onRetryPhotoUpload(event, emit, state, add));
  }

  @override
  Future<void> close() async {
    if (state is GymsLoadingState) {
      final gymsLoadingState = state as GymsLoadingState;
      if (!gymsLoadingState.loadGymsOp.isCompleted) {
        await gymsLoadingState.loadGymsOp.cancel();
      }
    }
    if (state is GymSelectedState) {
      await (state as GymSelectedState).cameraController.dispose();
    }
    if (state is CapturingState) {
      final capturingState = state as CapturingState;
      if (!capturingState.photoCapture.isCompleted) {
        await capturingState.photoCapture.cancel();
      }
    }
    if (state is RegisterRequestLoadingState) {
      final registeringState = state as RegisterRequestLoadingState;
      if (!registeringState.registerOp.isCompleted) {
        await registeringState.registerOp.cancel();
      }
    }
    if (state is UploadingPhotoState) {
      final uploadingState = state as UploadingPhotoState;
      if (!uploadingState.uploadOp.isCompleted) {
        await uploadingState.uploadOp.cancel();
      }
    }
    if (state is InitialState) {
      final initialState = state as InitialState;
      initialState.firstNameController.dispose();
      initialState.lastNameController.dispose();
      initialState.emailController.dispose();
      initialState.passwordController.dispose();
      initialState.confirmPasswordController.dispose();
      initialState.pageController.dispose();
      initialState.firstNameFocusNode.dispose();
      initialState.lastNameFocusNode.dispose();
      initialState.emailFocusNode.dispose();
      initialState.passwordFocusNode.dispose();
      initialState.confirmPasswordFocusNode.dispose();
    }
    return super.close();
  }
}
