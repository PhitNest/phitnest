import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phitnest_mobile/src/presentation/pages/registration/bloc/on_upload_success.dart';

import '../../../../domain/use_cases/use_cases.dart';
import '../event/registration_event.dart';
import '../state/registration_state.dart';
import 'on_capture_photo.dart';
import 'on_confirm_gym.dart';
import 'on_edit_first_name.dart';
import 'on_gym_loading_error.dart';
import 'on_gym_selected.dart';
import 'on_loaded_gyms.dart';
import 'on_read_photo_instructions.dart';
import 'on_register.dart';
import 'on_register_error.dart';
import 'on_register_success.dart';
import 'on_retake_photo.dart';
import 'on_retry_camera_init.dart';
import 'on_retry_load_gyms.dart';
import 'on_retry_photo_upload.dart';
import 'on_set_profile_picture.dart';
import 'on_upload_error.dart';
import 'on_validation_failed.dart';
import 'on_swipe.dart';

const pageAnimation = const Duration(milliseconds: 400);

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final pageController = PageController();
  final pageOneFormKey = GlobalKey<FormState>();
  final pageTwoFormKey = GlobalKey<FormState>();
  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  RegistrationBloc()
      : super(
          InitialState(
            firstNameConfirmed: false,
            loadGymsOp: CancelableOperation.fromFuture(loadGyms()),
            currentPage: 0,
            autovalidateMode: AutovalidateMode.disabled,
          ),
        ) {
    (state as InitialState).loadGymsOp.then(
          (either) => either.fold(
            (success) => add(LoadedGymsEvent(success.value1, success.value2)),
            (failure) => add(GymsLoadingErrorEvent(failure)),
          ),
        );
    on<RetryLoadGymsEvent>(
        (event, emit) => onRetryLoadGyms(event, emit, state, add));
    on<EditFirstNameEvent>(
        (event, emit) => onEditFirstName(event, emit, state));
    on<LoadedGymsEvent>((event, emit) => onLoadedGyms(event, emit, state));
    on<GymsLoadingErrorEvent>(
        (event, emit) => onGymsLoadingError(event, emit, state));
    on<GymSelectedEvent>((event, emit) => onGymSelected(event, emit, state));
    on<ConfirmGymEvent>(
      (event, emit) async {
        await onGymConfirmed(event, emit, state);
        pageController.nextPage(
          duration: pageAnimation,
          curve: Curves.easeInOut,
        );
      },
    );
    on<SwipeEvent>(
      (event, emit) {
        onSwipe(event, emit, state);
        firstNameFocusNode.unfocus();
        lastNameFocusNode.unfocus();
        emailFocusNode.unfocus();
        passwordFocusNode.unfocus();
        confirmPasswordFocusNode.unfocus();
      },
    );
    on<SubmitPageOneEvent>(
      (event, emit) {
        if (pageOneFormKey.currentState!.validate()) {
          pageController.nextPage(
            duration: pageAnimation,
            curve: Curves.easeInOut,
          );
        } else {
          onValidationFailed(emit, state);
        }
      },
    );
    on<SubmitPageTwoEvent>(
      (event, emit) {
        if (pageTwoFormKey.currentState!.validate()) {
          pageController.nextPage(
            duration: pageAnimation,
            curve: Curves.easeInOut,
          );
        } else {
          onValidationFailed(emit, state);
        }
      },
    );
    on<ReadPhotoInstructionsEvent>(
      (event, emit) {
        onReadPhotoInstructions(event, emit, state);
        pageController.nextPage(
          duration: pageAnimation,
          curve: Curves.easeInOut,
        );
      },
    );
    on<RetryCameraInitializationEvent>(
        (event, emit) => onRetryCameraInit(event, emit, state));
    on<CapturePhotoEvent>(
      (event, emit) => onCapturePhoto(event, emit, state, add),
    );
    on<SetProfilePictureEvent>(
        (event, emit) => onSetProfilePicture(event, emit, state));
    on<RetakeProfilePictureEvent>(
        (event, emit) => onRetakeProfilePicture(event, emit, state));
    on<RegisterEvent>(
      (event, emit) {
        onRegister(
          event,
          emit,
          state,
          add,
          pageController,
          firstNameController.text.trim(),
          lastNameController.text.trim(),
          emailController.text.trim(),
          passwordController.text.trim(),
          confirmPasswordController.text.trim(),
        );
      },
    );
    on<RegisterErrorEvent>(
      (event, emit) => onRegisterError(
        event,
        emit,
        state,
        add,
        pageController,
        emailController.text.trim(),
      ),
    );
    on<RegisterSuccessEvent>(
      (event, emit) => onRegisterSuccess(
        event,
        emit,
        state,
        add,
      ),
    );
    on<UploadErrorEvent>((event, emit) => onUploadError(event, emit, state));
    on<UploadSuccessEvent>(
        (event, emit) => onUploadSuccess(event, emit, state));
    on<RetryPhotoUploadEvent>(
        (event, emit) => onRetryPhotoUpload(event, emit, state, add));
  }

  @override
  Future<void> close() async {
    if (state is InitialState) {
      final initialState = state as InitialState;
      if (!initialState.loadGymsOp.isCompleted) {
        await initialState.loadGymsOp.cancel();
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
    if (state is RegisteringState) {
      final registeringState = state as RegisteringState;
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
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    pageController.dispose();
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    return super.close();
  }
}
