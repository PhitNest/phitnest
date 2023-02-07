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
        child: BlocConsumer<_ProfilePictureBloc, _ProfilePictureState>(
          listener: (context, state) {
            if (state is _UploadSuccessState) {
              Navigator.pop(context, state.file);
            }
          },
          builder: (context, state) {
            if (state is _Captured) {
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
            } else if (state is _Initialized) {
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
