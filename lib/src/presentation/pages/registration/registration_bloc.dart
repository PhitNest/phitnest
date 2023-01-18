import 'package:async/async.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../common/failure.dart';
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
          ),
        );
      },
    );
    on<CancelLoading>(
      (event, emit) {
        state.loadGyms.cancel();
      },
    );
    on<SwipeEvent>(
      (event, emit) {
        state.firstNameFocusNode.unfocus();
        state.lastNameFocusNode.unfocus();
        state.emailFocusNode.unfocus();
        state.passwordFocusNode.unfocus();
        state.confirmPasswordFocusNode.unfocus();
        emit(
          (state as RegistrationInitial).copyWith(
            pageIndex: event.pageIndex,
          ),
        );
      },
    );
    on<SubmitPageOne>(
      (event, emit) {
        final initialState = state as RegistrationInitial;
        if (state.pageOneFormKey.currentState!.validate()) {
          state.pageController.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
          emit(
            initialState.copyWith(
              pageIndex: 1,
              autovalidateMode: AutovalidateMode.disabled,
              pageScrollLimit: 3,
            ),
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
            pageScrollLimit: 5,
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
            curve: Curves.easeInOut);
        if (event.image != null) {
          emit(
            ProfilePictureUploaded(
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
            gymsLoadedState.copyWith(pageScrollLimit: 6, pageIndex: 5),
          );
        }
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
        emit(
          (state as GymsLoaded).copyWith(
            gym: event.gym,
            showMustSelectGymError: false,
            pageScrollLimit: 4,
          ),
        );
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
}
