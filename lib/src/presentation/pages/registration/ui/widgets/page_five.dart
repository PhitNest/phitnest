import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../common/theme.dart';
import '../../../../widgets/styled/styled.dart';

class PageFive extends StatelessWidget {
  final ValueChanged<XFile> onUploadedImage;
  final VoidCallback onPressedTakePhoto;

  const PageFive({
    Key? key,
    required this.onUploadedImage,
    required this.onPressedTakePhoto,
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
              'assets/images/pfp_meme.png',
              fit: BoxFit.contain,
            ),
          ),
          30.verticalSpace,
          StyledButton(
            onPressed: onPressedTakePhoto,
            text: 'TAKE PHOTO',
          ),
          Spacer(),
          StyledUnderlinedTextButton(
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
          32.verticalSpace,
        ],
      );
}
