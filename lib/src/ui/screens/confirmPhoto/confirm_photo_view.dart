import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
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
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: Column(
            children: [
              40.verticalSpace,
              Stack(
                children: [
                  BackArrowButton(),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Confirm Photo",
                      style: theme.textTheme.headlineLarge,
                    ),
                  ),
                ],
              ),
              40.verticalSpace,
              SizedBox(
                width: 262.w,
                height: 346.h,
                child: Image.asset('assets/images/phitnestSelfie.png'),
              ),
              20.verticalSpace,
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
        ),
      );
}
