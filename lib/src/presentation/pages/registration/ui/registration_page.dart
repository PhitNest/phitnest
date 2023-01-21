import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../domain/entities/entities.dart';
import '../../../widgets/styled/styled.dart';
import '../../pages.dart';
import '../bloc/registration_bloc.dart';
import '../event/registration_event.dart';
import '../state/registration_state.dart';
import 'widgets/gym_search/gym_search.dart';
import 'widgets/uploading/uploading.dart';
import 'widgets/widgets.dart';

RegistrationBloc _bloc(BuildContext context) =>
    context.read<RegistrationBloc>();

int _getPageScrollLimit(InitialState state) => state.firstNameConfirmed
    ? state is GymSelectedState
        ? state.gymConfirmed
            ? state.hasReadPhotoInstructions
                ? 6
                : 5
            : 4
        : 3
    : 1;

void _onSelectedGym(BuildContext context, GymEntity gym) =>
    _bloc(context).add(GymSelectedEvent(gym));

List<GymEntity> _filterGymsWithDuplicateNames(List<GymEntity> gyms) {
  List<GymEntity> filtered = [];
  for (final gym in gyms) {
    if (!filtered.any((element) => element.name == gym.name)) {
      filtered.add(gym);
    }
  }
  return filtered;
}

void _onPressedNoGym(BuildContext context) {}

void _onSetProfilePicture(BuildContext context, XFile photo) => _bloc(
      context,
    ).add(SetProfilePictureEvent(photo));

void _onPressedCapture(BuildContext context) =>
    _bloc(context).add(const CapturePhotoEvent());

void _onPressedRetake(BuildContext context) =>
    _bloc(context).add(const RetakeProfilePictureEvent());

void _onPressedSubmitPageSix(BuildContext context) =>
    _bloc(context).add(const RegisterEvent());

/// Handles registration and profile picture upload
class RegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => RegistrationBloc(),
        child: BlocConsumer<RegistrationBloc, RegistrationState>(
          listener: (context, state) {
            if (state is UploadSuccessState) {
              // On success, navigate to the confirm email page.
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ConfirmEmailPage(
                    email: state.registration.email,
                  ),
                ),
              );
            }
          },
          // Dark text for device status bar (time and battery, etc.)
          builder: (context, state) {
            // This is the height of the keyboard (0 if the keyboard is not visible)
            final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark,
              child: Scaffold(
                body: Builder(
                  builder: (context) {
                    // Registration form
                    if (state is InitialState) {
                      // Scrollable view prevents overflow errors and allows the user
                      // to dismiss the keyboard and scroll the page.
                      return SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        // Apply a size constraint to the page so that we can use Expanded
                        // widgets
                        child: SizedBox(
                          height: 1.sh,
                          child: Column(
                            children: [
                              // Swipeable page view
                              Expanded(
                                child: PageView.builder(
                                  // Emit SwipeEvent on page swipe
                                  onPageChanged: (value) =>
                                      _bloc(context).add(SwipeEvent(value)),
                                  controller: state.pageController,
                                  // Control the page the user is allowed to swipe to.
                                  // This is necessary because later screens may depend
                                  // the results of earlier screens.
                                  itemCount: _getPageScrollLimit(state),
                                  itemBuilder: (context, index) {
                                    switch (index) {
                                      // First page
                                      case 0:
                                        return PageOne(
                                          keyboardPadding: keyboardHeight,
                                          formKey: state.pageOneFormKey,
                                          firstNameController:
                                              state.firstNameController,
                                          lastNameController:
                                              state.lastNameController,
                                          autovalidateMode:
                                              state.autovalidateMode,
                                          onFirstNameEdited: (newValue) =>
                                              _bloc(context).add(
                                                  EditFirstNameEvent(newValue)),
                                          firstNameFocusNode:
                                              state.firstNameFocusNode,
                                          lastNameFocusNode:
                                              state.lastNameFocusNode,
                                          onSubmit: () => _bloc(context)
                                              .add(const SubmitPageOneEvent()),
                                        );
                                      // Second page
                                      case 1:
                                        return PageTwo(
                                          keyboardPadding: keyboardHeight,
                                          formKey: state.pageTwoFormKey,
                                          // If we have not selected a gym yet, there is no
                                          // possible way the user has encountered taken emails.
                                          // So we can leave it as an empty set otherwise. These
                                          // will be used to validate the email field.
                                          takenEmails:
                                              (state is GymSelectedState
                                                  ? state.takenEmails
                                                  : {}),
                                          emailController:
                                              state.emailController,
                                          passwordController:
                                              state.passwordController,
                                          autovalidateMode:
                                              state.autovalidateMode,
                                          emailFocusNode: state.emailFocusNode,
                                          passwordFocusNode:
                                              state.passwordFocusNode,
                                          // Emit the SubmitPageTwo event on completion
                                          onSubmit: () => _bloc(context)
                                              .add(const SubmitPageTwoEvent()),
                                          confirmPasswordController:
                                              state.confirmPasswordController,
                                          confirmPasswordFocusNode:
                                              state.confirmPasswordFocusNode,
                                          // Get the first name from page 1
                                          firstName: state
                                              .firstNameController.text
                                              .trim(),
                                        );
                                      // Page 3
                                      case 2:
                                        // If we are loading gyms, show the loading screen
                                        if (state is GymsLoadingState) {
                                          return PageThreeLoading(
                                            firstName: state
                                                .firstNameController.text
                                                .trim(),
                                            onPressedNoGym: () =>
                                                _onPressedNoGym(context),
                                          );
                                        } else if (state
                                            is GymsLoadingErrorState) {
                                          // There was an error loading gyms
                                          return PageThreeLoadingError(
                                            onPressedNoGym: () =>
                                                _onPressedNoGym(context),
                                            firstName: state
                                                .firstNameController.text
                                                .trim(),
                                            error: state.failure.message,
                                            onPressedRetry: () => _bloc(context)
                                                .add(
                                                    const RetryLoadGymsEvent()),
                                          );
                                        } else if (state is GymSelectedState) {
                                          // The user has selected a gym
                                          return PageThreeSelected(
                                            firstName: state
                                                .firstNameController.text
                                                .trim(),
                                            // Filter out gyms with duplicate names
                                            gyms: _filterGymsWithDuplicateNames(
                                                state.gyms),
                                            onSelected: (gym) =>
                                                _onSelectedGym(context, gym),
                                            onPressedNoGym: () =>
                                                _onPressedNoGym(context),
                                            gym: state.gym,
                                            onPressedNext: () =>
                                                state.pageController.nextPage(
                                              duration: const Duration(
                                                milliseconds: 400,
                                              ),
                                              curve: Curves.easeInOut,
                                            ),
                                          );
                                        } else if (state is GymsLoadedState) {
                                          // The user has not selected a gym yet
                                          return PageThreeNotSelected(
                                            firstName: state
                                                .firstNameController.text
                                                .trim(),
                                            onPressedNoGym: () =>
                                                _onPressedNoGym(context),
                                            gyms: _filterGymsWithDuplicateNames(
                                                state.gyms),
                                            onSelected: (gym) =>
                                                _onSelectedGym(context, gym),
                                          );
                                        }
                                        break;
                                      // Page 4
                                      case 3:
                                        // You should not be able to navigate to page 4 until
                                        // you have selected a gym.
                                        if (state is GymSelectedState) {
                                          return PageFour(
                                            gym: state.gym,
                                            onPressedYes: () => _bloc(context)
                                                .add(const ConfirmGymEvent()),
                                            // Use the result of the gym search page to set the gym
                                            onPressedNo: () => Navigator.push(
                                              context,
                                              CupertinoPageRoute<GymEntity?>(
                                                builder: (context) =>
                                                    GymSearchPage(
                                                  gyms: state.gyms,
                                                  location: state.location,
                                                  initialGym: state.gym,
                                                ),
                                              ),
                                            ).then(
                                              (gym) {
                                                // If the user updated their gym on the gym search page,
                                                // set the newly selected gym.
                                                if (gym != null) {
                                                  _onSelectedGym(context, gym);
                                                }
                                              },
                                            ),
                                          );
                                        } else {
                                          // The state should be a gym selected state at this point
                                          throw Exception(
                                              "Invalid state: $state");
                                        }
                                      // Page 5
                                      case 4:
                                        if (state
                                            is RegisterRequestLoadingState) {
                                          return PageFiveNoUpload(
                                            onPressedTakePhoto: () =>
                                                _bloc(context).add(
                                                    const ReadPhotoInstructionsEvent()),
                                          );
                                        } else if (state is GymSelectedState) {
                                          return PageFive(
                                            onUploadedImage: (image) => _bloc(
                                                context)
                                              ..add(
                                                  SetProfilePictureEvent(image))
                                              ..add(
                                                  const ReadPhotoInstructionsEvent()),
                                            onPressedTakePhoto: () =>
                                                _bloc(context).add(
                                                    const ReadPhotoInstructionsEvent()),
                                          );
                                        } else {
                                          // The state should be a gym selected state at this point
                                          throw Exception(
                                              "Invalid state: $state");
                                        }
                                      // Page 6
                                      case 5:
                                        if (state
                                            is RegisterRequestErrorState) {
                                          // There was an error with the register request
                                          return PageSixRegisterError(
                                            profilePicture: state.photo,
                                            onPressedRetake: () =>
                                                _onPressedRetake(context),
                                            onSubmit: () =>
                                                _onPressedSubmitPageSix(
                                                    context),
                                            onUploadPicture: (file) =>
                                                _onSetProfilePicture(
                                                    context, file),
                                            errorMessage: state.failure.message,
                                          );
                                        } else if (state
                                            is RegisterRequestLoadingState) {
                                          // The register request is loading
                                          return PageSixLoading(
                                            profilePicture: state.photo,
                                          );
                                        } else if (state
                                            is PhotoSelectedState) {
                                          // The user has selected a photo
                                          return PageSixPhotoSelected(
                                            onPressedRetake: () =>
                                                _onPressedRetake(context),
                                            profilePicture: state.photo,
                                            onSubmit: () =>
                                                _onPressedSubmitPageSix(
                                                    context),
                                            onUploadPicture: (file) =>
                                                _onSetProfilePicture(
                                                    context, file),
                                          );
                                        } else if (state is CaptureErrorState) {
                                          // There was an error capturing the photo
                                          return PageSixCaptureError(
                                            cameraController:
                                                state.cameraController,
                                            onUploadPicture: (file) =>
                                                _onSetProfilePicture(
                                                    context, file),
                                            onPressTakePicture: () =>
                                                _onPressedCapture(context),
                                            errorMessage: state.failure.message,
                                          );
                                        } else if (state is CapturingState) {
                                          // The user is capturing a photo
                                          return PageSixCapturing(
                                            cameraController:
                                                state.cameraController,
                                          );
                                        } else if (state is CameraErrorState) {
                                          // There was an error initializing the camera
                                          return PageSixCameraError(
                                            errorMessage: state.failure.message,
                                            onPressedRetry: () => context
                                                .read<RegistrationBloc>()
                                                .add(
                                                  const RetryCameraInitializationEvent(),
                                                ),
                                          );
                                        } else if (state is GymSelectedState) {
                                          // The user has selected a gym
                                          return PageSixInitial(
                                            cameraController:
                                                state.cameraController,
                                            onUploadPicture: (file) =>
                                                _onSetProfilePicture(
                                                    context, file),
                                            onPressTakePicture: () =>
                                                _onPressedCapture(context),
                                          );
                                        }
                                        break;
                                    }
                                    // The index should be between 0 and 5
                                    throw Exception('Invalid index: $index');
                                  },
                                ),
                              ),
                              StyledPageIndicator(
                                currentPage: state.currentPage,
                                totalPages: 6,
                              ),
                              48.verticalSpace,
                            ],
                          ),
                        ),
                      );
                      // User is uploading their profile picture or they have already uploaded it
                      // successfully.
                    } else if (state is UploadingPhotoState ||
                        state is UploadSuccessState) {
                      return const UploadingPhotoPage();
                    } else if (state is UploadErrorState) {
                      // There was an error uploading their profile picture
                      return UploadingErrorPage(
                        errorMessage: state.failure.message,
                        onRetry: () => context
                            .read<RegistrationBloc>()
                            .add(const RetryPhotoUploadEvent()),
                      );
                    } else {
                      throw Exception('Invalid state: $state');
                    }
                  },
                ),
              ),
            );
          },
        ),
      );
}
