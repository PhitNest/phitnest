import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme.dart';

class StyledTextFormField extends TextFormField {
  final TextEditingController? textController;
  final String labelText;
  final String? Function(String?)? validator;

  StyledTextFormField({
    super.key,
    required this.labelText,
    this.textController,
    this.validator,
  }) : super(
          cursorColor: const Color(0xFFB0AEB2),
          validator: validator,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: AppTheme.instance.theme.textTheme.bodySmall!.copyWith(
              color: const Color(0xFFF4F9FF),
              fontSize: 14.sp,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: Color(0xFFB0AEB2),
                width: 1.7,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: Color(0xFFB0AEB2),
                width: 1.7,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: Color(0xFFB0AEB2),
                width: 1.7,
              ),
            ),
          ),
          controller: textController,
        );
}
