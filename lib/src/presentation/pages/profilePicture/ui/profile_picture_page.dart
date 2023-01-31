import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/profile_picture_bloc.dart';
import '../event/profile_picture_event.dart';
import '../state/profile_picture_state.dart';
import 'widgets/widgets.dart';

ProfilePictureBloc _bloc(BuildContext context) => context.read();

void _onPressedRetake(BuildContext context) =>
    _bloc(context).add(const RetakePhotoEvent());

void _onUploadFromAlbums(BuildContext context, XFile image) {}

class ProfilePicturePage extends StatelessWidget {
  final XFile? initialImage;

  const ProfilePicturePage({Key? key, this.initialImage}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => ProfilePictureBloc(initialImage),
        child: BlocConsumer<ProfilePictureBloc, ProfilePictureState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is CaptureSuccessState) {
              return CapturedPhoto(
                profilePicture: state.file,
                onPressedRetake: () => _onPressedRetake(context),
                onUploadPicture: (file) => _onUploadFromAlbums(context, file),
                cameraController: state.cameraController,
              );
            } else if (state is CaptureLoadingState) {
              return Capturing(cameraController: state.cameraController);
            } else if (state is CaptureErrorState) {
              return CapturingError(
                cameraController: state.cameraController,
                onUploadPicture: (file) => _onUploadFromAlbums(context, file),
                onPressTakePicture: () => _onPressedRetake(context),
                errorMessage: state.failure.message,
              );
            } else if (state is CameraLoadedState) {
              return CameraActive(
                cameraController: state.cameraController,
                onUploadPicture: (file) => _onUploadFromAlbums(context, file),
                onPressTakePicture: () =>
                    _bloc(context).add(const CaptureEvent()),
              );
            } else if (state is CameraErrorState) {
              return CameraLoadingError(
                errorMessage: state.failure.message,
                onPressedRetry: () => _bloc(context).add(
                  const RetryInitializeCameraEvent(),
                ),
              );
            } else if (state is CameraLoadingState || state is InitialState) {
              return const CameraLoading();
            } else {
              throw Exception("Invalid state: $state");
            }
          },
        ),
      );
}
