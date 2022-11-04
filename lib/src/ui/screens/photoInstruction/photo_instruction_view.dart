import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/widgets.dart';
import '../view.dart';

class PhotoInstructionView extends ScreenView {
  final Function onPressedTakePhoto;
  const PhotoInstructionView({required this.onPressedTakePhoto}) : super();

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            32.verticalSpace,
            SizedBox(
              width: 278.w,
              child: Text(
                'Please take or upload a \npassport-style profile photo. \n\nPhotos must clearly show your face. \n\nNo body pictures are allowed.',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            24.verticalSpace,
            Container(
              child: Text(
                'EXAMPLE',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700),
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
                )),
            30.verticalSpace,
            TextButton(
                onPressed: () {},
                child: Text(
                  'UPLOAD FROM ALBUMS',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline),
                ))
          ],
        ),
      ),
    );
  }
}
