import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../view.dart';

class PhotoInstructionView extends ScreenView {
  final VoidCallback onPressedTakePhoto;

  const PhotoInstructionView({
    required this.onPressedTakePhoto,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            32.verticalSpace,
            SizedBox(
              width: 278.w,
              child: Text(
                'Please take or upload a \npassport-style profile photo. \n\nPhotos must clearly show your face. \n\nNo body pictures are allowed.',
                style: theme.textTheme.labelMedium,
              ),
            ),
            24.verticalSpace,
            Container(
              child: Text(
                'EXAMPLE',
                style: theme.textTheme.bodySmall!.copyWith(
                  color: theme.colorScheme.tertiary,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            12.verticalSpace,
            Container(
              width: double.infinity,
              height: 207.62.h,
              child: Image.asset(
                'assets/images/photoInstructions_img.png',
                fit: BoxFit.contain,
              ),
            ),
            40.38.verticalSpace,
            StyledButton(
              onPressed: () => onPressedTakePhoto,
              child: Text(
                'TAKE PHOTO',
              ),
            ),
            30.verticalSpace,
            TextButton(
              onPressed: () {},
              child: Text(
                'UPLOAD FROM ALBUMS',
                style: theme.textTheme.bodySmall!.copyWith(
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          ],
        ),
      );
}
