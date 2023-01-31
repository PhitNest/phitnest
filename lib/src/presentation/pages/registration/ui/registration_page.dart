import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/data_sources/backend/backend.dart';
import '../../../../data/data_sources/s3/s3.dart';
import '../../../../domain/entities/entities.dart';
import '../../../../domain/use_cases/use_cases.dart';
import '../../../widgets/styled/styled.dart';
import '../../pages.dart';
import '../bloc/registration_bloc.dart';
import '../event/registration_event.dart';
import '../state/registration_state.dart';
import 'widgets/widgets.dart';

RegistrationBloc _bloc(BuildContext context) =>
    context.read<RegistrationBloc>();

int _getPageScrollLimit(InitialState state) {
  if (state.firstNameConfirmed) {
    if (state is GymSelectedState) {
      return 4;
    } else {
      return 3;
    }
  } else {
    return 1;
  }
}

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

void _onPressedNotMyGym(BuildContext context, GymSelectedState state) =>
    Navigator.push(
      context,
      CupertinoPageRoute<GymEntity?>(
        builder: (context) => GymSearchPage(
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
    );

void _onPressedSubmitRegister(BuildContext context) =>
    _bloc(context).add(RegisterEvent());

void _onSubmitPhotoInstructions(BuildContext context, XFile? initialImage,
        RegisterSuccessState state) =>
    Navigator.push<XFile>(
      context,
      CupertinoPageRoute(
        builder: (context) => ProfilePicturePage(
          initialImage: initialImage,
          uploadImage: (photo) async {
            final failure = await uploadPhoto(state.response.uploadUrl, photo);
            if (failure != null) {
              return uploadPhotoUnauthorized(
                  state.response.user.email, state.password, photo);
            }
            return null;
          },
        ),
      ),
    ).then(
      (image) async {
        if (image != null) {
          final response = await Navigator.pushReplacement<LoginResponse, void>(
            context,
            CupertinoPageRoute(
              builder: (context) => ConfirmEmailPage(
                email: state.response.user.email,
                password: state.password,
              ),
            ),
          );
          if (response != null) {
            Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                builder: (context) => HomePage(
                  initialAccessToken: response.session.accessToken,
                  initialPassword: state.password,
                  initialRefreshToken: response.session.refreshToken,
                  initialUserData: response.user,
                ),
              ),
              (_) => false,
            );
          }
        }
      },
    );

/// Handles registration
class RegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => RegistrationBloc(),
        child: BlocConsumer<RegistrationBloc, RegistrationState>(
          listener: (context, state) {},
          // Dark text for device status bar (time and battery, etc.)
          builder: (context, state) {
            // This is the height of the keyboard (0 if the keyboard is not visible)
            final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
            if (state is RegisterSuccessState) {
              return ProfilePictureInstructions(
                onPressedTakePhoto: () =>
                    _onSubmitPhotoInstructions(context, null, state),
                onUploadFromAlbums: (file) =>
                    _onSubmitPhotoInstructions(context, file, state),
              );
            } else if (state is RegisterRequestLoadingState) {
              return const PageFourLoading();
            } else if (state is InitialState) {
              return StyledScaffold(
                body: SingleChildScrollView(
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
                                    autovalidateMode: state.autovalidateMode,
                                    onFirstNameEdited: (newValue) =>
                                        _bloc(context)
                                            .add(EditFirstNameEvent(newValue)),
                                    firstNameFocusNode:
                                        state.firstNameFocusNode,
                                    lastNameFocusNode: state.lastNameFocusNode,
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
                                    takenEmails: (state is GymSelectedState
                                        ? state.takenEmails
                                        : {}),
                                    emailController: state.emailController,
                                    passwordController:
                                        state.passwordController,
                                    autovalidateMode: state.autovalidateMode,
                                    emailFocusNode: state.emailFocusNode,
                                    passwordFocusNode: state.passwordFocusNode,
                                    // Emit the SubmitPageTwo event on completion
                                    onSubmit: () => _bloc(context)
                                        .add(const SubmitPageTwoEvent()),
                                    confirmPasswordController:
                                        state.confirmPasswordController,
                                    confirmPasswordFocusNode:
                                        state.confirmPasswordFocusNode,
                                    // Get the first name from page 1
                                    firstName:
                                        state.firstNameController.text.trim(),
                                  );
                                // Page 3
                                case 2:
                                  // If we are loading gyms, show the loading screen
                                  if (state is GymsLoadingState) {
                                    return PageThreeLoading(
                                      firstName:
                                          state.firstNameController.text.trim(),
                                      onPressedNoGym: () =>
                                          _onPressedNoGym(context),
                                    );
                                  } else if (state is GymsLoadingErrorState) {
                                    // There was an error loading gyms
                                    return PageThreeLoadingError(
                                      onPressedNoGym: () =>
                                          _onPressedNoGym(context),
                                      firstName:
                                          state.firstNameController.text.trim(),
                                      error: state.failure.message,
                                      onPressedRetry: () => _bloc(context)
                                          .add(const RetryLoadGymsEvent()),
                                    );
                                  } else if (state is GymSelectedState) {
                                    // The user has selected a gym
                                    return PageThreeSelected(
                                      firstName:
                                          state.firstNameController.text.trim(),
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
                                      firstName:
                                          state.firstNameController.text.trim(),
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
                                  if (state is RegisterRequestErrorState) {
                                    return PageFourError(
                                      gym: state.gym,
                                      onPressedYes: () =>
                                          _onPressedSubmitRegister(context),
                                      onPressedNo: () =>
                                          _onPressedNotMyGym(context, state),
                                      error: state.failure.message,
                                    );
                                  } else if (state is GymSelectedState) {
                                    return PageFour(
                                      gym: state.gym,
                                      onPressedYes: () =>
                                          _onPressedSubmitRegister(context),
                                      // Use the result of the gym search page to set the gym
                                      onPressedNo: () =>
                                          _onPressedNotMyGym(context, state),
                                    );
                                  } else {
                                    // The state should be a gym selected state at this point
                                    throw Exception("Invalid state: $state");
                                  }
                              }
                              // The index should be between 0 and 3
                              throw Exception('Invalid index: $index');
                            },
                          ),
                        ),
                        StyledPageIndicator(
                          currentPage: state.currentPage,
                          totalPages: 4,
                        ),
                        48.verticalSpace,
                      ],
                    ),
                  ),
                ),
              );
            } else {
              throw Exception('Invalid state: $state');
            }
          },
        ),
      );
}
