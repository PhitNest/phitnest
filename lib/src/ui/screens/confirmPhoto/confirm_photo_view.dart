import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/styled_button.dart';
import '../view.dart';

class ConfirmPhotoView extends ScreenView {
  @override
  String? get appBarText => "Confirm Photo";

  @override
  Widget build(BuildContext context) => Container(
        child: Column(children: [
          SizedBox(
            width: 262.w,
            height: 346.h,
            child: Image.asset('assets/images/phitnestSelfie.png'),
          ),
          38.verticalSpace,
          StyledButton(
              onPressed: () => [],
              child: Text(
                'CONFIRM',
              )),
          51.verticalSpace,
          TextButton(
              onPressed: () {},
              child: Text(
                'RETAKE',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline),
              ))
        ]),
      );
}
