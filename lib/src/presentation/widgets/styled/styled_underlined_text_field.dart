import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/theme.dart';

class StyledUnderlinedTextField extends StatelessWidget {
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
  final TextCapitalization textCapitalization;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onFieldSubmitted;

  const StyledUnderlinedTextField({
    Key? key,
    this.hint,
    this.error,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.onEditingComplete,
    this.onChanged,
    this.onFieldSubmitted,
    this.width,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        height: 50.h,
        child: TextFormField(
          onFieldSubmitted: onFieldSubmitted,
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          focusNode: focusNode,
          onEditingComplete: onEditingComplete,
          onChanged: onChanged,
          style: theme.textTheme.labelMedium,
          validator: validator,
          textCapitalization: textCapitalization,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 14.w, horizontal: 8.w),
            helperText: ' ',
            hintText: hint,
            errorText: error,
            errorMaxLines: 4,
            helperStyle: theme.textTheme.labelMedium,
            errorStyle:
                theme.textTheme.labelMedium!.copyWith(color: Colors.red),
            hintStyle:
                theme.textTheme.labelMedium!.copyWith(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
      );
}
