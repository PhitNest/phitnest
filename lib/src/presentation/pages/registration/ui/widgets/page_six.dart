import 'package:camera/camera.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../common/theme.dart';
import '../../../../widgets/styled/styled.dart';

class PageSixLoading extends _PageSixPhotoSelectedBase {
  const PageSixLoading({
    required super.profilePicture,
  }) : super(
          children: const [
            CircularProgressIndicator(),
          ],
        );
}

class PageSixRegisterError extends PageSixPhotoSelected {
  final String errorMessage;

  PageSixRegisterError({
    required super.profilePicture,
    required super.onPressedRetake,
    required super.onSubmit,
    required super.onUploadPicture,
    required this.errorMessage,
  }) : super(
          child: Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Text(
              errorMessage,
              style:
                  theme.textTheme.labelLarge!.copyWith(color: theme.errorColor),
              textAlign: TextAlign.center,
            ),
          ),
        );
}

class PageSixPhotoSelected extends _PageSixPhotoSelectedBase {
  final VoidCallback onSubmit;
  final VoidCallback onPressedRetake;
  final ValueChanged<XFile> onUploadPicture;
  final Widget? child;

  PageSixPhotoSelected({
    required super.profilePicture,
    required this.onPressedRetake,
    required this.onSubmit,
    required this.onUploadPicture,
    this.child,
  }) : super(
          children: [
            child ?? Container(),
            StyledButton(
              text: 'CONFIRM',
              onPressed: onSubmit,
            ),
            StyledUnderlinedTextButton(
              text: 'RETAKE',
              onPressed: onPressedRetake,
            ),
            Spacer(),
            StyledUnderlinedTextButton(
              text: 'ALBUMS',
              onPressed: () =>
                  ImagePicker().pickImage(source: ImageSource.gallery).then(
                (image) {
                  if (image != null) {
                    onUploadPicture(image);
                  }
                },
              ),
            ),
            32.verticalSpace,
          ],
        );
}

class _PageSixPhotoSelectedBase extends StatelessWidget {
  final XFile profilePicture;
  final List<Widget> children;

  const _PageSixPhotoSelectedBase({
    required this.profilePicture,
    required this.children,
  }) : super();

  @override
  Widget build(BuildContext context) => Column(
        children: [
          40.verticalSpace,
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                alignment: FractionalOffset.bottomCenter,
                image: XFileImage(
                  profilePicture,
                ),
              ),
            ),
            child: SizedBox(
              width: 1.sw,
              height: 333.h,
            ),
          ),
          20.verticalSpace,
          ...children,
        ],
      );
}

class PageSixCapturing extends _PageSixCameraActiveBase {
  PageSixCapturing({
    required super.cameraController,
  }) : super(
          children: [
            CircularProgressIndicator(),
          ],
        );
}

class PageSixCaptureError extends PageSixInitial {
  final String errorMessage;

  PageSixCaptureError({
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

class PageSixInitial extends _PageSixCameraActiveBase {
  final VoidCallback onPressTakePicture;
  final ValueChanged<XFile> onUploadPicture;
  final Widget? child;

  PageSixInitial({
    required super.cameraController,
    required this.onUploadPicture,
    required this.onPressTakePicture,
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
            StyledUnderlinedTextButton(
              text: 'ALBUMS',
              onPressed: () =>
                  ImagePicker().pickImage(source: ImageSource.gallery).then(
                (image) {
                  if (image != null) {
                    onUploadPicture(image);
                  }
                },
              ),
            ),
            32.verticalSpace,
          ],
        );
}

class _PageSixCameraActiveBase extends StatelessWidget {
  final CameraController cameraController;
  final List<Widget> children;

  const _PageSixCameraActiveBase({
    Key? key,
    required this.cameraController,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          40.verticalSpace,
          Container(
            width: 1.sw,
            height: 320.h,
            child: ClipRect(
              child: OverflowBox(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: SizedBox(
                    width: 1.sw,
                    height: 1.sh / cameraController.value.aspectRatio,
                    child: CameraPreview(
                      cameraController,
                      child: Center(
                        child: Opacity(
                          opacity: 0.75,
                          child: Image.asset(
                            'assets/images/profile_picture_mask.png',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          20.verticalSpace,
          ...children,
        ],
      );
}

class PageSixCameraError extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onPressedRetry;

  const PageSixCameraError({
    Key? key,
    required this.errorMessage,
    required this.onPressedRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          120.verticalSpace,
          Text(
            errorMessage,
            style:
                theme.textTheme.labelLarge!.copyWith(color: theme.errorColor),
            textAlign: TextAlign.center,
          ),
          24.verticalSpace,
          StyledButton(
            text: 'RETRY',
            onPressed: onPressedRetry,
          ),
        ],
      );
}
