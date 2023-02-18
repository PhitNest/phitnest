part of profile_picture_page;

class _CapturedPhotoPage extends _ICapturedPhotoPage {
  final VoidCallback onPressedConfirm;
  final VoidCallback onPressedRetake;
  final ValueChanged<XFile> onUploadPicture;
  final Widget? child;

  _CapturedPhotoPage({
    required super.profilePicture,
    required super.cameraController,
    required this.onPressedRetake,
    required this.onUploadPicture,
    required this.onPressedConfirm,
    this.child,
  }) : super(
          children: [
            child ?? Container(),
            StyledButton(
              text: 'CONFIRM',
              onPressed: onPressedConfirm,
            ),
            StyledUnderlinedTextButton(
              text: 'RETAKE',
              onPressed: onPressedRetake,
            ),
            Spacer(),
            _AlbumsButton(onUploadPicture: onUploadPicture),
            62.verticalSpace,
          ],
        );
}

class _UploadingPage extends _ICapturedPhotoPage {
  _UploadingPage({
    required super.profilePicture,
    required super.cameraController,
  }) : super(
          children: [
            CircularProgressIndicator(),
          ],
        );
}

class _ICapturedPhotoPage extends StatelessWidget {
  final XFile profilePicture;
  final CameraController cameraController;
  final List<Widget> children;

  const _ICapturedPhotoPage({
    required this.profilePicture,
    required this.cameraController,
    required this.children,
  }) : super();

  @override
  Widget build(BuildContext context) => StyledScaffold(
        body: Column(
          children: [
            40.verticalSpace,
            StyledBackButton(),
            Image(
              image: XFileImage(
                profilePicture,
              ),
              fit: BoxFit.fitWidth,
            ),
            20.verticalSpace,
            ...children,
          ],
        ),
      );
}
