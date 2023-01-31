import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/use_cases/use_cases.dart';
import '../event/registration_event.dart';
import '../state/registration_state.dart';
import 'on_edit_first_name.dart';
import 'on_gym_loading_error.dart';
import 'on_gym_selected.dart';
import 'on_gyms_loaded.dart';
import 'on_register.dart';
import 'on_register_error.dart';
import 'on_register_success.dart';
import 'on_retry_load_gyms.dart';
import 'on_submit_page_two.dart';
import 'on_submit_page_one.dart';
import 'on_swipe.dart';

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
    if (state is GymsLoadingState) {
      (state as GymsLoadingState).loadGymsOp.then(
            (either) => either.fold(
              (success) => add(GymsLoadedEvent(success.value1, success.value2)),
              (failure) => add(GymsLoadingErrorEvent(failure)),
            ),
          );
    } else {
      throw Exception('Invalid state: $state');
    }
    on<RetryLoadGymsEvent>(
        (event, emit) => onRetryLoadGyms(event, emit, state, add));
    on<EditFirstNameEvent>(
        (event, emit) => onEditFirstName(event, emit, state));
    on<GymsLoadedEvent>((event, emit) => onGymsLoaded(event, emit, state));
    on<GymsLoadingErrorEvent>(
        (event, emit) => onGymsLoadingError(event, emit, state));
    on<GymSelectedEvent>((event, emit) => onGymSelected(event, emit, state));
    on<SwipeEvent>((event, emit) => onSwipe(event, emit, state));
    on<SubmitPageOneEvent>(
        (event, emit) => onSubmitPageOne(event, emit, state));
    on<SubmitPageTwoEvent>(
        (event, emit) => onSubmitPageTwo(event, emit, state));
    on<RegisterEvent>((event, emit) => onRegister(event, emit, state, add));
    on<RegisterErrorEvent>(
        (event, emit) => onRegisterError(event, emit, state, add));
    on<RegisterSuccessEvent>(
        (event, emit) => onRegisterSuccess(event, emit, state, add));
  }

  @override
  Future<void> close() async {
    if (state is UploadingState) {
      final uploadingState = state as UploadingState;
      await uploadingState.uploadImage.cancel();
    }
    if (state is RegisterRequestLoadingState) {
      final registerRequestLoadingState = state as RegisterRequestLoadingState;
      await registerRequestLoadingState.registerOp.cancel();
    }
    if (state is GymsLoadingState) {
      final gymsLoadingState = state as GymsLoadingState;
      if (!gymsLoadingState.loadGymsOp.isCompleted) {
        await gymsLoadingState.loadGymsOp.cancel();
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
