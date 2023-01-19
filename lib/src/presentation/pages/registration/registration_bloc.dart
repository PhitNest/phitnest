import 'dart:math';

import 'package:async/async.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../common/failure.dart';
import '../../../common/validators.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../bloc.dart';
import 'registration_event.dart';
import 'registration_state.dart';

typedef LoadGymsResponse
    = Either<Tuple2<List<GymEntity>, LocationEntity>, Failure>;

Future<LoadGymsResponse> loadGyms() => locationRepository.getLocation().then(
      (either) => either.fold(
        (location) => gymRepository.getNearest(location, 30000000).then(
              (either) => either.leftMap(
                (list) => Tuple2(list, location),
              ),
            ),
        (failure) => Right(failure),
      ),
    );

class RegistrationBloc extends PageBloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc()
      : super(
          RegistrationInitial(
            pageScrollLimit: 1,
            firstNameController: TextEditingController(),
            lastNameController: TextEditingController(),
            emailController: TextEditingController(),
            passwordController: TextEditingController(),
            confirmPasswordController: TextEditingController(),
            autovalidateMode: AutovalidateMode.disabled,
            firstNameFocusNode: FocusNode(),
            lastNameFocusNode: FocusNode(),
            emailFocusNode: FocusNode(),
            passwordFocusNode: FocusNode(),
            confirmPasswordFocusNode: FocusNode(),
            pageOneFormKey: GlobalKey(),
            pageTwoFormKey: GlobalKey(),
            pageController: PageController(),
            loadGyms: CancelableOperation.fromFuture(loadGyms()),
            pageIndex: 0,
          ),
        ) {
    state.loadGyms.then(
      (response) => response.fold(
        (result) => add(
          GymsLoadedEvent(
            gyms: result.value1,
            location: result.value2,
          ),
        ),
        (failure) => add(
          GymLoadedErrorEvent(
            failure: failure,
          ),
        ),
      ),
    );
    on<UploadingPicture>(
      (event, emit) {
        final gymsLoadedState = state as GymsLoaded;
        emit(
          UploadPictureLoading(
            takenEmails: gymsLoadedState.takenEmails,
            autovalidateMode: state.autovalidateMode,
            confirmPasswordController: state.confirmPasswordController,
            emailController: state.emailController,
            firstNameController: state.firstNameController,
            lastNameController: state.lastNameController,
            passwordController: state.passwordController,
            pageIndex: state.pageIndex,
            pageOneFormKey: state.pageOneFormKey,
            pageTwoFormKey: state.pageTwoFormKey,
            firstNameFocusNode: state.firstNameFocusNode,
            lastNameFocusNode: state.lastNameFocusNode,
            emailFocusNode: state.emailFocusNode,
            passwordFocusNode: state.passwordFocusNode,
            confirmPasswordFocusNode: state.confirmPasswordFocusNode,
            pageController: state.pageController,
            loadGyms: state.loadGyms,
            gyms: gymsLoadedState.gyms,
            gym: gymsLoadedState.gym,
            showMustSelectGymError: gymsLoadedState.showMustSelectGymError,
            location: gymsLoadedState.location,
            pageScrollLimit: state.pageScrollLimit,
            cameraController: gymsLoadedState.cameraController,
          ),
        );
      },
    );
    on<GymLoadedErrorEvent>(
      (event, emit) {
        emit(
          GymsLoadingError(
            pageScrollLimit: state.pageScrollLimit,
            autovalidateMode: state.autovalidateMode,
            confirmPasswordController: state.confirmPasswordController,
            emailController: state.emailController,
            firstNameController: state.firstNameController,
            lastNameController: state.lastNameController,
            passwordController: state.passwordController,
            pageIndex: state.pageIndex,
            pageOneFormKey: state.pageOneFormKey,
            pageTwoFormKey: state.pageTwoFormKey,
            firstNameFocusNode: state.firstNameFocusNode,
            lastNameFocusNode: state.lastNameFocusNode,
            emailFocusNode: state.emailFocusNode,
            passwordFocusNode: state.passwordFocusNode,
            confirmPasswordFocusNode: state.confirmPasswordFocusNode,
            pageController: state.pageController,
            loadGyms: state.loadGyms,
            failure: event.failure,
          ),
        );
      },
    );
    on<GymsLoadedEvent>(
      (event, emit) async {
        emit(
          GymsLoaded(
            cameraController: CameraController(
              (await availableCameras()).first,
              ResolutionPreset.max,
              enableAudio: false,
            ),
            takenEmails: {},
            autovalidateMode: state.autovalidateMode,
            gyms: event.gyms,
            firstNameController: state.firstNameController,
            lastNameController: state.lastNameController,
            emailController: state.emailController,
            passwordController: state.passwordController,
            confirmPasswordController: state.confirmPasswordController,
            firstNameFocusNode: state.firstNameFocusNode,
            lastNameFocusNode: state.lastNameFocusNode,
            emailFocusNode: state.emailFocusNode,
            passwordFocusNode: state.passwordFocusNode,
            confirmPasswordFocusNode: state.confirmPasswordFocusNode,
            pageOneFormKey: state.pageOneFormKey,
            pageTwoFormKey: state.pageTwoFormKey,
            pageController: state.pageController,
            loadGyms: state.loadGyms,
            pageScrollLimit: state.pageScrollLimit,
            pageIndex: state.pageIndex,
            showMustSelectGymError: false,
            location: event.location,
            gym: null,
          ),
        );
      },
    );

    on<SwipeEvent>(
      (event, emit) {
        state.firstNameFocusNode.unfocus();
        state.lastNameFocusNode.unfocus();
        state.emailFocusNode.unfocus();
        state.passwordFocusNode.unfocus();
        state.confirmPasswordFocusNode.unfocus();
        if (state is UploadPictureLoading) {
          emit(
            (state as UploadPictureLoading).copyWith(
              pageIndex: event.pageIndex,
            ),
          );
        } else if (state is ProfilePictureUploaded) {
          emit(
            (state as ProfilePictureUploaded).copyWith(
              pageIndex: event.pageIndex,
            ),
          );
        } else if (state is GymsLoaded) {
          emit(
            (state as GymsLoaded).copyWith(
              pageIndex: event.pageIndex,
            ),
          );
        } else {
          emit(
            (state as RegistrationInitial).copyWith(
              pageIndex: event.pageIndex,
            ),
          );
        }
      },
    );
    on<SubmitPageOne>(
      (event, emit) {
        final initialState = state as RegistrationInitial;
        if (state.pageOneFormKey.currentState!.validate()) {
          if (state is ProfilePictureUploaded) {
            emit(
              initialState.copyWith(
                pageIndex: 2,
                autovalidateMode: AutovalidateMode.disabled,
                pageScrollLimit: 6,
              ),
            );
          } else if (state is GymsLoaded) {
            final gymsLoadedState = state as GymsLoaded;
            if (gymsLoadedState.gym != null) {
              emit(
                initialState.copyWith(
                  pageIndex: 2,
                  autovalidateMode: AutovalidateMode.disabled,
                  pageScrollLimit: 4,
                ),
              );
            } else {
              emit(
                initialState.copyWith(
                  pageIndex: 2,
                  autovalidateMode: AutovalidateMode.disabled,
                  pageScrollLimit: 3,
                ),
              );
            }
          } else {
            emit(
              initialState.copyWith(
                pageIndex: 2,
                autovalidateMode: AutovalidateMode.disabled,
                pageScrollLimit: 3,
              ),
            );
          }
          state.pageController.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        } else {
          emit(
            initialState.copyWith(
              autovalidateMode: AutovalidateMode.always,
              pageScrollLimit: 1,
            ),
          );
        }
      },
    );
    on<SubmitPageTwo>(
      (event, emit) {
        final initialState = state as RegistrationInitial;
        if (state.pageTwoFormKey.currentState!.validate()) {
          state.pageController.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
          emit(
            initialState.copyWith(
              pageIndex: 2,
              autovalidateMode: AutovalidateMode.disabled,
            ),
          );
        } else {
          emit(
            initialState.copyWith(
              autovalidateMode: AutovalidateMode.always,
            ),
          );
        }
      },
    );
    on<SubmitPageThree>(
      (event, emit) {
        final gymsLoadedState = state as GymsLoaded;
        if (gymsLoadedState.gym == null) {
          emit(
            gymsLoadedState.copyWith(showMustSelectGymError: true),
          );
        } else {
          emit(
            gymsLoadedState.copyWith(pageIndex: 3),
          );
          state.pageController.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      },
    );
    on<SubmitPageFour>(
      (event, emit) {
        emit(
          (state as GymsLoaded).copyWith(
            pageScrollLimit: max(5, state.pageScrollLimit),
          ),
        );
        state.pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        emit(
          (state as GymsLoaded).copyWith(pageIndex: 4),
        );
      },
    );
    on<SubmitPageFive>(
      (event, emit) async {
        final gymsLoadedState = state as GymsLoaded;
        await gymsLoadedState.cameraController.initialize();
        state.pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        if (event.image != null) {
          emit(
            ProfilePictureUploaded(
              takenEmails: gymsLoadedState.takenEmails,
              cameraController: gymsLoadedState.cameraController,
              autovalidateMode: state.autovalidateMode,
              confirmPasswordController: state.confirmPasswordController,
              emailController: state.emailController,
              firstNameController: state.firstNameController,
              lastNameController: state.lastNameController,
              passwordController: state.passwordController,
              firstNameFocusNode: state.firstNameFocusNode,
              lastNameFocusNode: state.lastNameFocusNode,
              emailFocusNode: state.emailFocusNode,
              passwordFocusNode: state.passwordFocusNode,
              confirmPasswordFocusNode: state.confirmPasswordFocusNode,
              pageOneFormKey: state.pageOneFormKey,
              pageTwoFormKey: state.pageTwoFormKey,
              pageController: state.pageController,
              loadGyms: state.loadGyms,
              pageScrollLimit: 6,
              pageIndex: 5,
              showMustSelectGymError: false,
              location: gymsLoadedState.location,
              gym: gymsLoadedState.gym,
              gyms: gymsLoadedState.gyms,
              profilePicture: event.image!,
            ),
          );
        } else {
          emit(
            GymsLoaded(
              takenEmails: gymsLoadedState.takenEmails,
              cameraController: gymsLoadedState.cameraController,
              autovalidateMode: state.autovalidateMode,
              confirmPasswordController: state.confirmPasswordController,
              emailController: state.emailController,
              firstNameController: state.firstNameController,
              lastNameController: state.lastNameController,
              passwordController: state.passwordController,
              firstNameFocusNode: state.firstNameFocusNode,
              lastNameFocusNode: state.lastNameFocusNode,
              emailFocusNode: state.emailFocusNode,
              passwordFocusNode: state.passwordFocusNode,
              confirmPasswordFocusNode: state.confirmPasswordFocusNode,
              pageOneFormKey: state.pageOneFormKey,
              pageTwoFormKey: state.pageTwoFormKey,
              pageController: state.pageController,
              loadGyms: state.loadGyms,
              pageScrollLimit: 6,
              pageIndex: 5,
              showMustSelectGymError: false,
              location: gymsLoadedState.location,
              gym: gymsLoadedState.gym,
              gyms: gymsLoadedState.gyms,
            ),
          );
        }
      },
    );
    on<SubmitPageSix>(
      (event, emit) {
        final submittedState = state as ProfilePictureUploaded;
        if (validateEmail(state.emailController.text.trim()) != null ||
            validatePassword(state.passwordController.text) != null ||
            state.confirmPasswordController.text !=
                state.passwordController.text) {
          state.pageController.jumpToPage(1);
          emit(
            submittedState.copyWith(
              pageIndex: 1,
              autovalidateMode: AutovalidateMode.always,
            ),
          );
          Future.delayed(Duration(milliseconds: 50),
              () => state.pageTwoFormKey.currentState!.validate());
        } else {
          emit(
            RegistrationLoading(
              takenEmails: submittedState.takenEmails,
              autovalidateMode: state.autovalidateMode,
              confirmPasswordController: state.confirmPasswordController,
              emailController: state.emailController,
              firstNameController: state.firstNameController,
              lastNameController: state.lastNameController,
              passwordController: state.passwordController,
              pageIndex: state.pageIndex,
              pageOneFormKey: state.pageOneFormKey,
              pageTwoFormKey: state.pageTwoFormKey,
              firstNameFocusNode: state.firstNameFocusNode,
              lastNameFocusNode: state.lastNameFocusNode,
              emailFocusNode: state.emailFocusNode,
              passwordFocusNode: state.passwordFocusNode,
              confirmPasswordFocusNode: state.confirmPasswordFocusNode,
              pageController: state.pageController,
              loadGyms: state.loadGyms,
              gyms: submittedState.gyms,
              gym: submittedState.gym!,
              showMustSelectGymError: submittedState.showMustSelectGymError,
              location: submittedState.location,
              pageScrollLimit: state.pageScrollLimit,
              cameraController: submittedState.cameraController,
              profilePicture: submittedState.profilePicture,
              registerOp: CancelableOperation.fromFuture(
                authRepository.register(
                  state.emailController.text.trim(),
                  state.passwordController.text.trim(),
                  state.firstNameController.text.trim(),
                  state.lastNameController.text.trim(),
                  submittedState.gym!.id,
                ),
              )..then(
                  (res) => res.fold(
                    (success) => add(const RegistrationRequestSuccessEvent()),
                    (failure) {
                      if (failure.code == "UsernameExistsException") {
                        add(const UserTakenEvent());
                      } else {
                        add(RegistrationRequestErrorEvent(failure: failure));
                      }
                    },
                  ),
                ),
            ),
          );
        }
      },
    );
    on<RegistrationRequestErrorEvent>(
      (event, emit) {
        final submittedState = state as RegistrationLoading;
        emit(
          RegistrationRequestErrorState(
            autovalidateMode: state.autovalidateMode,
            confirmPasswordController: state.confirmPasswordController,
            emailController: state.emailController,
            firstNameController: state.firstNameController,
            lastNameController: state.lastNameController,
            passwordController: state.passwordController,
            pageIndex: state.pageIndex,
            pageOneFormKey: state.pageOneFormKey,
            pageTwoFormKey: state.pageTwoFormKey,
            firstNameFocusNode: state.firstNameFocusNode,
            lastNameFocusNode: state.lastNameFocusNode,
            emailFocusNode: state.emailFocusNode,
            passwordFocusNode: state.passwordFocusNode,
            confirmPasswordFocusNode: state.confirmPasswordFocusNode,
            pageController: state.pageController,
            loadGyms: state.loadGyms,
            gyms: submittedState.gyms,
            gym: submittedState.gym,
            showMustSelectGymError: submittedState.showMustSelectGymError,
            location: submittedState.location,
            pageScrollLimit: state.pageScrollLimit,
            cameraController: submittedState.cameraController,
            profilePicture: submittedState.profilePicture,
            takenEmails: submittedState.takenEmails,
            failure: event.failure,
          ),
        );
        Future.delayed(
          Duration(milliseconds: 50),
          () => state.pageController.jumpToPage(6),
        );
      },
    );
    on<UserTakenEvent>(
      (event, emit) {
        final submittedState = state as ProfilePictureUploaded;
        emit(
          ProfilePictureUploaded(
            confirmPasswordController: state.confirmPasswordController,
            emailController: state.emailController,
            firstNameController: state.firstNameController,
            lastNameController: state.lastNameController,
            passwordController: state.passwordController,
            pageOneFormKey: state.pageOneFormKey,
            pageTwoFormKey: state.pageTwoFormKey,
            firstNameFocusNode: state.firstNameFocusNode,
            lastNameFocusNode: state.lastNameFocusNode,
            emailFocusNode: state.emailFocusNode,
            passwordFocusNode: state.passwordFocusNode,
            confirmPasswordFocusNode: state.confirmPasswordFocusNode,
            pageController: state.pageController,
            loadGyms: state.loadGyms,
            gyms: submittedState.gyms,
            gym: submittedState.gym,
            showMustSelectGymError: submittedState.showMustSelectGymError,
            location: submittedState.location,
            pageScrollLimit: state.pageScrollLimit,
            cameraController: submittedState.cameraController,
            profilePicture: submittedState.profilePicture,
            pageIndex: 1,
            takenEmails: {
              ...submittedState.takenEmails,
              state.emailController.text.trim(),
            },
            autovalidateMode: AutovalidateMode.always,
          ),
        );
        Future.delayed(
          Duration(milliseconds: 50),
          () => state.pageController.jumpToPage(1),
        ).then(
          (_) => Future.delayed(
            Duration(milliseconds: 50),
            () => state.pageTwoFormKey.currentState!.validate(),
          ),
        );
      },
    );
    on<PageOneTextEdited>(
      (event, emit) {
        emit(
          (state as RegistrationInitial).copyWith(
            pageScrollLimit: 1,
          ),
        );
      },
    );
    on<RefreshGymsEvent>(
      (event, emit) {
        final gymOp = CancelableOperation<LoadGymsResponse>.fromFuture(
          loadGyms(),
        )..then(
            (response) => response.fold(
              (result) => add(
                GymsLoadedEvent(gyms: result.value1, location: result.value2),
              ),
              (failure) => add(
                GymLoadedErrorEvent(
                  failure: failure,
                ),
              ),
            ),
          );
        emit(
          RegistrationInitial(
            autovalidateMode: state.autovalidateMode,
            confirmPasswordController: state.confirmPasswordController,
            emailController: state.emailController,
            firstNameController: state.firstNameController,
            lastNameController: state.lastNameController,
            passwordController: state.passwordController,
            pageIndex: state.pageIndex,
            pageOneFormKey: state.pageOneFormKey,
            pageTwoFormKey: state.pageTwoFormKey,
            pageScrollLimit: state.pageScrollLimit,
            firstNameFocusNode: state.firstNameFocusNode,
            lastNameFocusNode: state.lastNameFocusNode,
            emailFocusNode: state.emailFocusNode,
            passwordFocusNode: state.passwordFocusNode,
            confirmPasswordFocusNode: state.confirmPasswordFocusNode,
            pageController: state.pageController,
            loadGyms: gymOp,
          ),
        );
      },
    );
    on<SetGymEvent>(
      (event, emit) {
        if (state is ProfilePictureUploaded) {
          emit(
            (state as ProfilePictureUploaded).copyWith(
              gym: event.gym,
              showMustSelectGymError: false,
              pageScrollLimit: 6,
            ),
          );
        } else if (state is GymsLoaded) {
          emit(
            (state as GymsLoaded).copyWith(
              gym: event.gym,
              showMustSelectGymError: false,
              pageScrollLimit: 4,
            ),
          );
        }
      },
    );
    on<SetProfilePictureEvent>(
      (event, emit) {
        if (event.image != null) {
          final gymsLoadedState = state as GymsLoaded;
          emit(
            ProfilePictureUploaded(
              takenEmails: gymsLoadedState.takenEmails,
              cameraController: gymsLoadedState.cameraController,
              autovalidateMode: state.autovalidateMode,
              confirmPasswordController: state.confirmPasswordController,
              emailController: state.emailController,
              firstNameController: state.firstNameController,
              lastNameController: state.lastNameController,
              passwordController: state.passwordController,
              firstNameFocusNode: state.firstNameFocusNode,
              lastNameFocusNode: state.lastNameFocusNode,
              emailFocusNode: state.emailFocusNode,
              passwordFocusNode: state.passwordFocusNode,
              confirmPasswordFocusNode: state.confirmPasswordFocusNode,
              pageOneFormKey: state.pageOneFormKey,
              pageTwoFormKey: state.pageTwoFormKey,
              pageController: state.pageController,
              loadGyms: state.loadGyms,
              pageScrollLimit: state.pageScrollLimit,
              pageIndex: state.pageIndex,
              showMustSelectGymError: false,
              location: gymsLoadedState.location,
              gym: gymsLoadedState.gym,
              gyms: gymsLoadedState.gyms,
              profilePicture: event.image!,
            ),
          );
        } else {
          final gymsLoadedState = state as GymsLoaded;
          emit(
            GymsLoaded(
              takenEmails: gymsLoadedState.takenEmails,
              autovalidateMode: state.autovalidateMode,
              confirmPasswordController: state.confirmPasswordController,
              emailController: state.emailController,
              firstNameController: state.firstNameController,
              lastNameController: state.lastNameController,
              passwordController: state.passwordController,
              pageIndex: state.pageIndex,
              pageOneFormKey: state.pageOneFormKey,
              pageTwoFormKey: state.pageTwoFormKey,
              firstNameFocusNode: state.firstNameFocusNode,
              lastNameFocusNode: state.lastNameFocusNode,
              emailFocusNode: state.emailFocusNode,
              passwordFocusNode: state.passwordFocusNode,
              confirmPasswordFocusNode: state.confirmPasswordFocusNode,
              pageController: state.pageController,
              loadGyms: state.loadGyms,
              pageScrollLimit: state.pageScrollLimit,
              showMustSelectGymError: gymsLoadedState.showMustSelectGymError,
              gyms: gymsLoadedState.gyms,
              location: gymsLoadedState.location,
              cameraController: gymsLoadedState.cameraController,
              gym: gymsLoadedState.gym,
            ),
          );
        }
      },
    );
  }

  void editedPageOne() => add(const PageOneTextEdited());

  void submitPageOne() => add(const SubmitPageOne());

  void submitPageTwo() => add(const SubmitPageTwo());

  void swipe(int pageIndex) => add(SwipeEvent(pageIndex: pageIndex));

  void refreshGyms() => add(const RefreshGymsEvent());

  void setGym(GymEntity? gym) => add(SetGymEvent(gym: gym));

  void submitPageThree() => add(const SubmitPageThree());

  void submitPageFour() => add(const SubmitPageFour());

  void submitPageFive(XFile? image) => add(SubmitPageFive(image));

  void setProfilePicture(XFile? image) => add(SetProfilePictureEvent(image));

  void submitPageSix() => add(const SubmitPageSix());

  void uploadingPicture() => add(const UploadingPicture());
}
