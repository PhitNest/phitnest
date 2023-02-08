import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constants/assets.dart';

class StyledProfilePictureCamera extends StatelessWidget {
  final CameraController cameraController;

  const StyledProfilePictureCamera({
    Key? key,
    required this.cameraController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 1.sw,
        height: 1.sw * 333.0 / 375.0,
        child: ClipRect(
          child: OverflowBox(
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: SizedBox(
                height: 1.sw * 333.0 / 375.0,
                child: CameraPreview(
                  cameraController,
                  child: SizedBox(
                    width: 1.sw,
                    child: Opacity(
                      opacity: 0.48,
                      child: Image.asset(
                        Assets.profilePictureMask.path,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
