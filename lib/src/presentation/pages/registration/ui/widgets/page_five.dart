import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../common/constants/assets.dart';
import '../../../../../common/theme.dart';
import '../../../../widgets/styled/styled.dart';

class PageFiveNoUpload extends _PageFiveBase {
  const PageFiveNoUpload({
    Key? key,
    required super.onPressedTakePhoto,
  }) : super(key: key);
}

class PageFive extends _PageFiveBase {
  final ValueChanged<XFile> onUploadedImage;

  PageFive({
    Key? key,
    required super.onPressedTakePhoto,
    required this.onUploadedImage,
  }) : super(
          key: key,
          child: StyledUnderlinedTextButton(
            onPressed: () =>
                ImagePicker().pickImage(source: ImageSource.gallery).then(
              (image) {
                if (image != null) {
                  onUploadedImage(image);
                }
              },
            ),
            text: 'UPLOAD FROM ALBUMS',
          ),
        );
}

class _PageFiveBase extends StatelessWidget {
  final VoidCallback onPressedTakePhoto;
  final Widget? child;

  const _PageFiveBase({
    Key? key,
    required this.onPressedTakePhoto,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          96.verticalSpace,
          Text(
            "Let's put a face\nto your name",
            style: theme.textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          30.verticalSpace,
          Text(
            "Add a photo of yourself\n**from the SHOULDERS UP**\n\nJust enough for your gym buddies\nto recognize you!",
            style: theme.textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
          12.verticalSpace,
          Container(
            width: 160.h,
            child: Image.asset(
              Assets.profilePictureMeme.path,
              fit: BoxFit.contain,
            ),
          ),
          30.verticalSpace,
          StyledButton(
            onPressed: onPressedTakePhoto,
            text: 'TAKE PHOTO',
          ),
          Spacer(),
          child ?? Container(),
          32.verticalSpace,
        ],
      );
}
