import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/failure.dart';
import '../bloc/profile_picture_bloc.dart';
import '../event/profile_picture_event.dart';
import '../state/profile_picture_state.dart';
import 'widgets/widgets.dart';

ProfilePictureBloc _bloc(BuildContext context) => context.read();

void _onPressedRetake(BuildContext context) =>
    _bloc(context).add(const RetakePhotoEvent());

void _onPressedTakePicture(BuildContext context) =>
    _bloc(context).add(const CaptureEvent());

void _onUploadFromAlbums(BuildContext context, XFile image) =>
    _bloc(context).add(CaptureSuccessEvent(image));

void _onUpload(BuildContext context) => _bloc(context).add(const UploadEvent());

class ProfilePicturePage extends StatelessWidget {
  final XFile? initialImage;
  final Future<Failure?> Function(XFile image) uploadImage;

  const ProfilePicturePage({
    Key? key,
    required this.uploadImage,
    this.initialImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => ProfilePictureBloc(
          initialImage: initialImage,
          uploadImage: uploadImage,
        ),
        child: BlocConsumer<ProfilePictureBloc, ProfilePictureState>(
          listener: (context, state) {
            if (state is UploadSuccessState) {
              Navigator.pop(context, state.file);
            }
          },
          builder: (context, state) {
            if (state is UploadSuccessState) {
              return Uploading(
                profilePicture: state.file,
                cameraController: state.cameraController,
              );
            } else if (state is UploadingState) {
              return Uploading(
                profilePicture: state.file,
                cameraController: state.cameraController,
              );
            } else if (state is UploadErrorState) {
              return UploadingError(
                cameraController: state.cameraController,
                profilePicture: state.file,
                onUploadPicture: (file) => _onUploadFromAlbums(context, file),
                onPressedConfirm: () => _onUpload(context),
                failure: state.failure,
                onPressedRetake: () => _onPressedRetake(context),
              );
            } else if (state is CaptureSuccessState) {
              return CapturedPhoto(
                profilePicture: state.file,
                onPressedRetake: () => _onPressedRetake(context),
                onUploadPicture: (file) => _onUploadFromAlbums(context, file),
                cameraController: state.cameraController,
                onPressedConfirm: () => _onUpload(context),
              );
            } else if (state is CaptureLoadingState) {
              return Capturing(cameraController: state.cameraController);
            } else if (state is CaptureErrorState) {
              return CapturingError(
                cameraController: state.cameraController,
                onUploadPicture: (file) => _onUploadFromAlbums(context, file),
                onPressTakePicture: () => _onPressedTakePicture(context),
                errorMessage: state.failure.message,
              );
            } else if (state is CameraLoadedState) {
              return CameraActive(
                cameraController: state.cameraController,
                onUploadPicture: (file) => _onUploadFromAlbums(context, file),
                onPressTakePicture: () => _onPressedTakePicture(context),
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
