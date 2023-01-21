import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app_bloc.dart';
import '../../../../app_event.dart';
import '../../../../domain/entities/entities.dart';
import '../../../widgets/styled/styled.dart';
import '../../pages.dart';
import '../bloc/registration_bloc.dart';
import '../event/registration_event.dart';
import '../state/registration_state.dart';
import 'widgets/gym_search/gym_search.dart';
import 'widgets/uploading/uploading.dart';
import 'widgets/widgets.dart';

class RegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => RegistrationBloc(),
        child: BlocBuilder<RegistrationBloc, RegistrationState>(
          builder: (context, state) {
            final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark,
              child: Scaffold(
                body: Builder(
                  builder: (context) {
                    if (state is RegistrationBase) {
                      return SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        child: SizedBox(
                          height: 1.sh,
                          child: Column(
                            children: [
                              Expanded(
                                child: PageView.builder(
                                  onPageChanged: (value) =>
                                      context.read<RegistrationBloc>().add(
                                            SwipeEvent(value),
                                          ),
                                  controller: context
                                      .read<RegistrationBloc>()
                                      .pageController,
                                  itemCount: state.firstNameConfirmed
                                      ? state is GymSelectedState
                                          ? state.gymConfirmed
                                              ? state.hasReadPhotoInstructions
                                                  ? 6
                                                  : 5
                                              : 4
                                          : 3
                                      : 1,
                                  itemBuilder: (context, index) {
                                    RegistrationBloc bloc = context.read();
                                    switch (index) {
                                      case 0:
                                        return PageOne(
                                          keyboardPadding: keyboardPadding,
                                          formKey: bloc.pageOneFormKey,
                                          firstNameController:
                                              bloc.firstNameController,
                                          lastNameController:
                                              bloc.lastNameController,
                                          autovalidateMode:
                                              state.autovalidateMode,
                                          onFirstNameEdited: (newValue) =>
                                              context
                                                  .read<RegistrationBloc>()
                                                  .add(
                                                    EditFirstNameEvent(
                                                        newValue),
                                                  ),
                                          firstNameFocusNode:
                                              bloc.firstNameFocusNode,
                                          lastNameFocusNode:
                                              bloc.lastNameFocusNode,
                                          onSubmit: () => context
                                              .read<RegistrationBloc>()
                                              .add(
                                                SubmitPageOneEvent(),
                                              ),
                                        );
                                      case 1:
                                        return PageTwo(
                                          keyboardPadding: keyboardPadding,
                                          formKey: bloc.pageTwoFormKey,
                                          takenEmails:
                                              (state is GymSelectedState
                                                  ? state.takenEmails
                                                  : {}),
                                          emailController: bloc.emailController,
                                          passwordController:
                                              bloc.passwordController,
                                          autovalidateMode:
                                              state.autovalidateMode,
                                          emailFocusNode: bloc.emailFocusNode,
                                          passwordFocusNode:
                                              bloc.passwordFocusNode,
                                          onSubmit: () => context
                                              .read<RegistrationBloc>()
                                              .add(
                                                SubmitPageTwoEvent(),
                                              ),
                                          confirmPasswordController:
                                              bloc.confirmPasswordController,
                                          confirmPasswordFocusNode:
                                              bloc.confirmPasswordFocusNode,
                                          firstName: bloc
                                              .firstNameController.text
                                              .trim(),
                                        );
                                      case 2:
                                        final String firstName = bloc
                                            .firstNameController.text
                                            .trim();
                                        final void Function() onPressedNoGym =
                                            () {};
                                        final List<GymEntity> Function(
                                                List<GymEntity>)
                                            filterDuplicateNames =
                                            (gyms) => gyms
                                                .where(
                                                  (element) =>
                                                      gyms
                                                          .where(
                                                            (innerLoop) =>
                                                                innerLoop
                                                                    .name ==
                                                                element.name,
                                                          )
                                                          .length ==
                                                      1,
                                                )
                                                .toList();
                                        final ValueChanged<GymEntity>
                                            onSelectedGym = (gym) => context
                                                .read<RegistrationBloc>()
                                                .add(
                                                  GymSelectedEvent(gym),
                                                );
                                        if (state is InitialState) {
                                          return PageThreeLoading(
                                            firstName: firstName,
                                            onPressedNoGym: onPressedNoGym,
                                          );
                                        } else if (state
                                            is GymsLoadingErrorState) {
                                          return PageThreeLoadingError(
                                            onPressedNoGym: onPressedNoGym,
                                            firstName: firstName,
                                            error: state.failure.message,
                                            onPressedRetry: () => context
                                                .read<RegistrationBloc>()
                                                .add(
                                                  RetryLoadGymsEvent(),
                                                ),
                                          );
                                        } else if (state is GymSelectedState) {
                                          return PageThreeSelected(
                                            firstName: firstName,
                                            gyms: filterDuplicateNames(
                                                state.gyms),
                                            onSelected: onSelectedGym,
                                            onPressedNoGym: onPressedNoGym,
                                            gym: state.gym,
                                            onPressedNext: () => context
                                                .read<RegistrationBloc>()
                                                .pageController
                                                .nextPage(
                                                  duration: const Duration(
                                                    milliseconds: 400,
                                                  ),
                                                  curve: Curves.easeInOut,
                                                ),
                                          );
                                        } else if (state
                                            is GymNotSelectedState) {
                                          return PageThreeNotSelected(
                                            firstName: firstName,
                                            onPressedNoGym: onPressedNoGym,
                                            gyms: filterDuplicateNames(
                                                state.gyms),
                                            onSelected: onSelectedGym,
                                          );
                                        }
                                        break;
                                      case 3:
                                        final gymSelectionState =
                                            state as GymSelectedState;
                                        return PageFour(
                                          gym: gymSelectionState.gym,
                                          onPressedYes: () => context
                                              .read<RegistrationBloc>()
                                              .add(
                                                ConfirmGymEvent(),
                                              ),
                                          onPressedNo: () => Navigator.push(
                                            context,
                                            CupertinoPageRoute<GymEntity?>(
                                              builder: (context) =>
                                                  GymSearchPage(
                                                gyms: gymSelectionState.gyms,
                                                location:
                                                    gymSelectionState.location,
                                                initialGym: state.gym,
                                              ),
                                            ),
                                          ).then(
                                            (gym) {
                                              if (gym != null) {
                                                context
                                                    .read<RegistrationBloc>()
                                                    .add(GymSelectedEvent(gym));
                                              }
                                            },
                                          ),
                                        );
                                      case 4:
                                        return PageFive(
                                          onUploadedImage: (image) {
                                            if (!(state is RegisteringState ||
                                                state is UploadingPhotoState)) {
                                              context.read<RegistrationBloc>()
                                                ..add(
                                                  SetProfilePictureEvent(image),
                                                )
                                                ..add(
                                                  ReadPhotoInstructionsEvent(),
                                                );
                                            }
                                          },
                                          onPressedTakePhoto: () => context
                                              .read<RegistrationBloc>()
                                              .add(
                                                ReadPhotoInstructionsEvent(),
                                              ),
                                        );
                                      case 5:
                                        final ValueChanged<XFile>
                                            onUploadPicture = (file) => context
                                                .read<RegistrationBloc>()
                                                .add(
                                                  SetProfilePictureEvent(file),
                                                );
                                        final VoidCallback onPressTakePicture =
                                            () => context
                                                .read<RegistrationBloc>()
                                                .add(
                                                  CapturePhotoEvent(),
                                                );
                                        final VoidCallback onPressedRetake =
                                            () => context
                                                .read<RegistrationBloc>()
                                                .add(
                                                  RetakeProfilePictureEvent(),
                                                );
                                        final VoidCallback onSubmit = () =>
                                            context
                                                .read<RegistrationBloc>()
                                                .add(RegisterEvent());
                                        if (state is RegisterErrorState) {
                                          return PageSixRegisterError(
                                            profilePicture: state.photo,
                                            onPressedRetake: onPressedRetake,
                                            onSubmit: onSubmit,
                                            onUploadPicture: onUploadPicture,
                                            errorMessage: state.failure.message,
                                          );
                                        } else if (state is RegisteringState) {
                                          return PageSixLoading(
                                            profilePicture: state.photo,
                                          );
                                        } else if (state
                                            is PhotoSelectedState) {
                                          return PageSixPhotoSelected(
                                            onPressedRetake: onPressedRetake,
                                            profilePicture: state.photo,
                                            onSubmit: onSubmit,
                                            onUploadPicture: onUploadPicture,
                                          );
                                        } else if (state is CaptureErrorState) {
                                          return PageSixCaptureError(
                                            cameraController:
                                                state.cameraController,
                                            onUploadPicture: onUploadPicture,
                                            onPressTakePicture:
                                                onPressTakePicture,
                                            errorMessage: state.failure.message,
                                          );
                                        } else if (state is CapturingState) {
                                          return PageSixCapturing(
                                            cameraController:
                                                state.cameraController,
                                          );
                                        } else if (state is CameraErrorState) {
                                          return PageSixCameraError(
                                            errorMessage: state.failure.message,
                                            onPressedRetry: () => context
                                                .read<RegistrationBloc>()
                                                .add(
                                                  RetryCameraInitializationEvent(),
                                                ),
                                          );
                                        } else if (state is GymSelectedState) {
                                          return PageSixInitial(
                                            cameraController:
                                                state.cameraController,
                                            onUploadPicture: onUploadPicture,
                                            onPressTakePicture:
                                                onPressTakePicture,
                                          );
                                        }
                                        break;
                                    }
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
                    } else if (state is UploadingPhotoState) {
                      return const UploadingPhotoPage();
                    } else if (state is UploadErrorState) {
                      return UploadingErrorPage(
                        errorMessage: state.failure.message,
                        onRetry: () => context.read<RegistrationBloc>().add(
                              RetryPhotoUploadEvent(),
                            ),
                      );
                    } else if (state is UploadSuccessState) {
                      Future.delayed(
                        Duration.zero,
                        () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConfirmEmailPage(
                              email: state.registration.email,
                            ),
                          ),
                        ),
                      );
                      return Scaffold(body: Container());
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
