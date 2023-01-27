import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/failure.dart';
import '../../../../../common/theme.dart';
import '../../../../widgets/styled/styled.dart';
import 'base.dart';

class VerificationError extends VerificationBase {
  final VoidCallback onPressedResend;
  final Failure error;

  VerificationError({
    Key? key,
    required super.codeController,
    required super.codeFocusNode,
    required super.onCompleted,
    required super.headerText,
    required super.email,
    required this.error,
    required this.onPressedResend,
  }) : super(
          key: key,
          child: Column(
            children: [
              8.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  error.message,
                  style: theme.textTheme.labelLarge!
                      .copyWith(color: theme.errorColor),
                  textAlign: TextAlign.center,
                ),
              ),
              16.verticalSpace,
              StyledButton(
                text: 'RETRY',
                onPressed: onCompleted,
              ),
              Spacer(),
              StyledUnderlinedTextButton(
                onPressed: onPressedResend,
                text: 'RESEND CODE',
              ),
              37.verticalSpace,
            ],
          ),
        );
}
