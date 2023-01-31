import 'package:camera/camera.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../widgets/widgets.dart';
import 'albums_button.dart';

class CapturedPhoto extends StatelessWidget {
  final XFile profilePicture;
  final VoidCallback onPressedRetake;
  final ValueChanged<XFile> onUploadPicture;
  final CameraController cameraController;

  const CapturedPhoto({
    required this.profilePicture,
    required this.onPressedRetake,
    required this.onUploadPicture,
    required this.cameraController,
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
            StyledButton(
              text: 'CONFIRM',
              onPressed: () => Navigator.pop(context, profilePicture),
            ),
            StyledUnderlinedTextButton(
              text: 'RETAKE',
              onPressed: onPressedRetake,
            ),
            Spacer(),
            AlbumsButton(onUploadPicture: onUploadPicture),
            32.verticalSpace,
          ],
        ),
      );
}
