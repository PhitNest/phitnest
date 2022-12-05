import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/widgets.dart';
import '../view.dart';

class ConfirmPhotoView extends ScreenView {
  final VoidCallback onPressedConfirm;
  final VoidCallback onPressedRetake;

  const ConfirmPhotoView({
    required this.onPressedConfirm,
    required this.onPressedRetake,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            40.verticalSpace,
            Stack(
              children: [
                BackArrowButton(),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 10.h),
                  child: Text(
                    "Confirm Photo",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 262.w,
              height: 346.h,
              child: Image.asset('assets/images/phitnestSelfie.png'),
            ),
            38.verticalSpace,
            StyledButton(
                onPressed: onPressedConfirm,
                child: Text(
                  'CONFIRM',
                )),
            Expanded(child: Container()),
            TextButtonWidget(
              onPressed: onPressedRetake,
              text: 'RETAKE',
            ),
            37.verticalSpace,
          ],
        ),
      );
}
