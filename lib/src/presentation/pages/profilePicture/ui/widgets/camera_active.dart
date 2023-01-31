import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/theme.dart';
import '../../../../widgets/widgets.dart';
import 'albums_button.dart';

class Capturing extends _CameraActiveBase {
  Capturing({
    required super.cameraController,
  }) : super(
          children: [
            CircularProgressIndicator(),
          ],
        );
}

class CapturingError extends CameraActive {
  final String errorMessage;

  CapturingError({
    required super.cameraController,
    required super.onUploadPicture,
    required super.onPressTakePicture,
    required this.errorMessage,
  }) : super(
          child: Text(
            errorMessage,
            style:
                theme.textTheme.labelLarge!.copyWith(color: theme.errorColor),
            textAlign: TextAlign.center,
          ),
        );
}

class CameraActive extends _CameraActiveBase {
  final VoidCallback onPressTakePicture;
  final ValueChanged<XFile> onUploadPicture;
  final Widget? child;

  CameraActive({
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            10.verticalSpace,
            child ?? Container(),
            Spacer(),
            AlbumsButton(onUploadPicture: onUploadPicture),
            32.verticalSpace,
          ],
        );
}

class _CameraActiveBase extends StatelessWidget {
  final CameraController cameraController;
  final List<Widget> children;

  const _CameraActiveBase({
    Key? key,
    required this.cameraController,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            40.verticalSpace,
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
