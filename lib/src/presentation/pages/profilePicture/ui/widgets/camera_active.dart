part of profile_picture_page;

class _CaptureLoadingPage extends _CameraActiveBasePage {
  const _CaptureLoadingPage({
    required super.cameraController,
  }) : super(
          children: const [
            CircularProgressIndicator(),
          ],
        );
}

class _CameraActivePage extends _CameraActiveBasePage {
  final VoidCallback onPressTakePicture;
  final ValueChanged<XFile> onUploadPicture;
  final Widget? child;

  _CameraActivePage({
    required super.cameraController,
    required this.onPressTakePicture,
    required this.onUploadPicture,
    this.child,
  }) : super(
          children: [
            OutlinedButton(
              onPressed: onPressTakePicture,
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.black,
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
            10.verticalSpace,
            child ?? Container(),
            Spacer(),
            _AlbumsButton(onUploadPicture: onUploadPicture),
            62.verticalSpace,
          ],
        );
}

class _CameraActiveBasePage extends StatelessWidget {
  final CameraController cameraController;
  final List<Widget> children;

  const _CameraActiveBasePage({
    Key? key,
    required this.cameraController,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StyledScaffold(
        body: Column(
          children: [
            StyledBackButton(),
            StyledProfilePictureCamera(
              cameraController: cameraController,
            ),
            20.verticalSpace,
            ...children,
          ],
        ),
      );
}
