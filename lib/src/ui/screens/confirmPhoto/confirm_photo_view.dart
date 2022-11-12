import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../view.dart';

class ConfirmPhotoView extends ScreenView {
  @override
  String? get appBarText => "Confirm Photo";

  @override
  Widget buildView(BuildContext context) => Container(
            child: Image.asset(
              'assets/images/phitnestSelfie.png',
              height: 346.h,
            ),
          );
}