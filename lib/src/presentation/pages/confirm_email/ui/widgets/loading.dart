import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'base.dart';

class ConfirmEmailLoading extends ConfirmEmailBaseWidget {
  ConfirmEmailLoading({
    Key? key,
    required super.codeController,
    required super.codeFocusNode,
    required super.onChanged,
    required super.onCompleted,
    required super.email,
  }) : super(
          key: key,
          child: Column(
            children: [
              20.verticalSpace,
              CircularProgressIndicator(),
            ],
          ),
        );
}
