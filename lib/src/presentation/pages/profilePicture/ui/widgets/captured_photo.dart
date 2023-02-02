part of profile_picture_page;

class _UploadingErrorPage extends _CapturedPhotoPage {
  final Failure failure;

  _UploadingErrorPage({
    required super.profilePicture,
    required super.onUploadPicture,
    required super.cameraController,
    required super.onPressedRetake,
    required super.onPressedConfirm,
    required this.failure,
  }) : super(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 12.h,
            ),
            child: Text(
              failure.message,
              style:
                  theme.textTheme.labelLarge!.copyWith(color: theme.errorColor),
              textAlign: TextAlign.center,
            ),
          ),
        );
}

class _CapturedPhotoPage extends _CapturedPhotoBasePage {
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

class _UploadingPage extends _CapturedPhotoBasePage {
  _UploadingPage({
    required super.profilePicture,
    required super.cameraController,
  }) : super(
          children: [
            CircularProgressIndicator(),
          ],
        );
}

class _CapturedPhotoBasePage extends StatelessWidget {
  final XFile profilePicture;
  final CameraController cameraController;
  final List<Widget> children;

  const _CapturedPhotoBasePage({
    required this.profilePicture,
    required this.cameraController,
    required this.children,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
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
