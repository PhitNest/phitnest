import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../common/constants/assets.dart';
import '../../../../../common/theme.dart';
import '../../../../widgets/styled/styled.dart';

class ProfilePictureInstructions extends StatelessWidget {
  final VoidCallback onPressedTakePhoto;
  final ValueChanged<XFile> onUploadFromAlbums;

  const ProfilePictureInstructions({
    Key? key,
    required this.onPressedTakePhoto,
    required this.onUploadFromAlbums,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StyledScaffold(
        body: Column(
          children: [
            double.infinity.horizontalSpace,
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
            StyledUnderlinedTextButton(
              onPressed: () =>
                  ImagePicker().pickImage(source: ImageSource.gallery).then(
                (image) {
                  if (image != null) {
                    onUploadFromAlbums(image);
                  }
                },
              ),
              text: 'UPLOAD FROM ALBUMS',
            ),
            62.verticalSpace,
          ],
        ),
      );
}
