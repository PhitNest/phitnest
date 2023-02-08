import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/theme.dart';

class StyledTextField extends StatelessWidget {
  final String? hint;
  final String? error;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onChanged;
  final double? width;
  final double? height;
  final TextCapitalization textCapitalization;
  final int? maxLines;
  final ValueChanged<String>? onFieldSubmitted;
  final int? errorMaxLines;

  const StyledTextField({
    Key? key,
    this.hint,
    this.error,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines,
    this.textInputAction,
    this.focusNode,
    this.onEditingComplete,
    this.onChanged,
    this.width,
    this.onFieldSubmitted,
    this.height,
    this.textCapitalization = TextCapitalization.none,
    this.errorMaxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        height: height,
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          focusNode: focusNode,
          maxLines: maxLines,
          onEditingComplete: onEditingComplete,
          onChanged: onChanged,
          style: theme.textTheme.labelMedium,
          textCapitalization: textCapitalization,
          decoration: InputDecoration(
            fillColor: Colors.white,
            contentPadding:
                EdgeInsets.symmetric(vertical: 14.w, horizontal: 14.w),
            helperText: ' ',
            hintText: hint,
            errorText: error,
            errorMaxLines: errorMaxLines,
            helperStyle: theme.textTheme.labelMedium,
            errorStyle:
                theme.textTheme.labelMedium!.copyWith(color: Colors.red),
            hintStyle: theme.textTheme.labelMedium,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
      );
}
