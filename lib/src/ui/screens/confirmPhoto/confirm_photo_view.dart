import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../../widgets/widgets.dart';
import '../view.dart';

class ConfirmPhotoView extends ScreenView {
  final VoidCallback onPressedConfirm;
  final VoidCallback onPressedRetake;
  final bool loading;
  final String? errorMessage;

  const ConfirmPhotoView({
    required this.onPressedConfirm,
    required this.onPressedRetake,
    required this.loading,
    required this.errorMessage,
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
              Visibility(
                visible: !loading,
                child: StyledButton(
                  onPressed: onPressedConfirm,
                  child: Text(
                    errorMessage != null ? 'RETRY' : 'CONFIRM',
                  ),
                ),
              ),
              Visibility(
                visible: loading,
                child: CircularProgressIndicator(),
              ),
              20.verticalSpace,
              Visibility(
                visible: !loading && errorMessage != null,
                child: SizedBox(
                  width: 0.9.sw,
                  child: Text(
                    errorMessage ?? "",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelMedium!.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ),
              Expanded(child: Container()),
              Visibility(
                visible: !loading,
                child: TextButtonWidget(
                  onPressed: onPressedRetake,
                  text: 'RETAKE',
                ),
              ),
              37.verticalSpace,
            ],
          ),
        ),
      );
}
