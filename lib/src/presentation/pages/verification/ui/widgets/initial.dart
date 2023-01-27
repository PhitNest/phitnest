import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../widgets/styled/styled.dart';
import 'base.dart';

class VerificationInitial extends VerificationBase {
  final VoidCallback onPressedResend;

  VerificationInitial({
    Key? key,
    required super.codeController,
    required super.codeFocusNode,
    required super.onCompleted,
    required super.headerText,
    required super.email,
    required this.onPressedResend,
  }) : super(
          key: key,
          child: Column(
            children: [
              20.verticalSpace,
              StyledButton(
                text: 'SUBMIT',
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
