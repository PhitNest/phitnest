import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../common/theme.dart';

class StyledVerificationField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onCompleted;
  final FocusNode? focusNode;

  const StyledVerificationField({
    Key? key,
    this.controller,
    this.focusNode,
    required this.onChanged,
    required this.onCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 280.w,
        child: PinCodeTextField(
          appContext: context,
          length: 6,
          onChanged: onChanged,
          onCompleted: onCompleted,
          controller: controller,
          focusNode: focusNode,
          textStyle: theme.textTheme.labelLarge,
          keyboardType: TextInputType.number,
          pinTheme: PinTheme(
            activeColor: Colors.grey.shade600,
            selectedColor: Colors.black,
            inactiveColor: Colors.grey.shade400,
            fieldWidth: 40.w,
          ),
        ),
      );
}
