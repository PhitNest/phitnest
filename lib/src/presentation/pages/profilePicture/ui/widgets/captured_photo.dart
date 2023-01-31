import 'package:camera/camera.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/failure.dart';
import '../../../../../common/theme.dart';
import '../../../../widgets/widgets.dart';
import 'albums_button.dart';

class UploadingError extends CapturedPhoto {
  final Failure failure;

  UploadingError({
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

class CapturedPhoto extends _CapturedPhotoBase {
  final VoidCallback onPressedConfirm;
  final VoidCallback onPressedRetake;
  final ValueChanged<XFile> onUploadPicture;
  final Widget? child;

  CapturedPhoto({
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
            AlbumsButton(onUploadPicture: onUploadPicture),
            62.verticalSpace,
          ],
        );
}

class Uploading extends _CapturedPhotoBase {
  Uploading({
    required super.profilePicture,
    required super.cameraController,
  }) : super(
          children: [
            CircularProgressIndicator(),
          ],
        );
}

class _CapturedPhotoBase extends StatelessWidget {
  final XFile profilePicture;
  final CameraController cameraController;
  final List<Widget> children;

  const _CapturedPhotoBase({
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
