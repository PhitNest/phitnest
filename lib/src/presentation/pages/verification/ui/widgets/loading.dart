import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'base.dart';

class VerificationLoading extends VerificationBase {
  VerificationLoading({
    Key? key,
    required super.codeController,
    required super.codeFocusNode,
    required super.headerText,
    required super.email,
  }) : super(
          key: key,
          onCompleted: () {},
          child: Column(
            children: [
              20.verticalSpace,
              CircularProgressIndicator(),
            ],
          ),
        );
}
