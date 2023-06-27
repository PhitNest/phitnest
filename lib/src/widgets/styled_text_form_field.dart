import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme.dart';

class StyledTextFormField extends TextFormField {
  final TextEditingController textController;
  final String labelText;

  StyledTextFormField({
    super.key,
    required this.textController,
    required this.labelText,
  }) : super(
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: AppTheme.instance.theme.textTheme.bodySmall!.copyWith(
              color: const Color(0xFFF4F9FF),
              fontSize: 14.sp,
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
            ),
          ),
          controller: textController,
        );
}
