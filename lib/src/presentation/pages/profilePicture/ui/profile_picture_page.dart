part of profile_picture_page;

extension _Bloc on BuildContext {
  _ProfilePictureBloc get bloc => read();

  void retake() => bloc.add(const _RetakePhotoEvent());

  void capture() => bloc.add(const _CaptureEvent());

  void upload() => bloc.add(const _UploadEvent());

  void retryInitializeCamera() => bloc.add(const _RetryInitializeCameraEvent());

  void uploadFromAlbums(XFile image) => bloc.add(_CaptureSuccessEvent(image));
}

class ProfilePicturePage extends StatelessWidget {
  final XFile? initialImage;
  final Future<Failure?> Function(XFile image) uploadImage;

  /// **POP RESULT: [XFile] if the profile picture is uploaded successfully**
  ///
  /// This page is used to upload a profile picture. There are different ways a user can
  /// upload a profile picture: unauthorized or authorized.
  ///
  /// The [UseCases.uploadPhotoUnauthorized] method should be used for users who have not yet
  /// confirmed their account. Once they confirm their account this route will no longer work.
  /// Once the user has confirmed their account, they will have access to a more secure route,
  /// [UseCases.uploadPhotoAuthorized].
  ///
  /// [initialImage] can be provided if the user has already selected an image before coming to
  /// this page.
  const ProfilePicturePage({
    Key? key,
    required this.uploadImage,
    this.initialImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => _ProfilePictureBloc(
          initialImage: initialImage,
          uploadImage: uploadImage,
        ),
        child: BlocConsumer<_ProfilePictureBloc, _IProfilePictureState>(
          listener: (context, state) {
            if (state is _UploadSuccessState) {
              Navigator.pop(context, state.file);
            }
          },
          builder: (context, state) {
            if (state is _ICapturedState) {
              if (state is _UploadErrorState) {
                return _UploadingErrorPage(
                  profilePicture: state.file,
                  onUploadPicture: context.uploadFromAlbums,
                  cameraController: state.cameraController,
                  onPressedRetake: context.retake,
                  onPressedConfirm: context.upload,
                  failure: state.failure,
                );
              } else if (state is _CaptureSuccessState) {
                return _CapturedPhotoPage(
                  profilePicture: state.file,
                  cameraController: state.cameraController,
                  onPressedRetake: context.retake,
                  onUploadPicture: context.uploadFromAlbums,
                  onPressedConfirm: context.upload,
                );
              } else {
                return _UploadingPage(
                  profilePicture: state.file,
                  cameraController: state.cameraController,
                );
              }
            } else if (state is _IInitializedState) {
              if (state is _CaptureErrorState) {
                return _CaptureErrorPage(
                  cameraController: state.cameraController,
                  onUploadPicture: context.uploadFromAlbums,
                  onPressTakePicture: context.capture,
                  errorMessage: state.failure.message,
                );
              } else if (state is _CaptureLoadingState) {
                return _CaptureLoadingPage(
                  cameraController: state.cameraController,
                );
              } else {
                return _CameraActivePage(
                  cameraController: state.cameraController,
                  onUploadPicture: context.uploadFromAlbums,
                  onPressTakePicture: context.capture,
                );
              }
            } else if (state is _CameraErrorState) {
              return _CameraLoadingErrorPage(
                errorMessage: state.failure.message,
                onPressedRetry: context.retryInitializeCamera,
              );
            } else {
              return const _CameraLoadingPage();
            }
          },
        ),
      );
}
