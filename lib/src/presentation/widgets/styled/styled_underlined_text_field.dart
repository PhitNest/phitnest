import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/theme.dart';

class StyledUnderlinedTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onChanged;
  final TextCapitalization textCapitalization;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final int? errorMaxLines;
  final Widget? suffix;

  const StyledUnderlinedTextField({
    Key? key,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.onEditingComplete,
    this.onChanged,
    this.onFieldSubmitted,
    this.errorMaxLines,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TextFormField(
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
          suffix: suffix,
          contentPadding: EdgeInsets.only(
            bottom: 8.h,
            left: 8.w,
            right: 8.w,
          ),
          helperText: ' ',
          hintText: hint,
          isDense: true,
          errorMaxLines: errorMaxLines,
          helperStyle: theme.textTheme.labelMedium,
          errorStyle: theme.textTheme.labelMedium!.copyWith(color: Colors.red),
          hintStyle: theme.textTheme.labelMedium!.copyWith(color: Colors.grey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      );
}
