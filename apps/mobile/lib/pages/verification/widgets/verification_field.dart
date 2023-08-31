import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_core/core.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

final class VerificationField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onCompleted;

  const VerificationField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 280.w,
        child: PinCodeTextField(
          appContext: context,
          length: 6,
          validator: (code) => code!.length == 6 ? null : '',
          onChanged: onChanged,
          onCompleted: onCompleted,
          textStyle: theme.textTheme.bodyLarge,
          controller: controller,
          focusNode: focusNode,
          autoDisposeControllers: false,
          keyboardType: TextInputType.number,
          pinTheme: PinTheme(
            activeColor: Colors.grey.shade600,
            selectedColor: Colors.grey.shade600,
            inactiveColor: Colors.grey.shade400,
            fieldWidth: 40.w,
          ),
        ),
      );
}
