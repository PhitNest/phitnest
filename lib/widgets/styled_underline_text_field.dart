import 'package:flutter/material.dart';

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
  final String? Function(dynamic)? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final int? errorMaxLines;
  final Widget? suffix;

  const StyledUnderlinedTextField({
    super.key,
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
  }) : super();

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
        validator: validator,
        textCapitalization: textCapitalization,
        decoration: InputDecoration(
          suffix: suffix,
          contentPadding: const EdgeInsets.only(
            bottom: 10,
            left: 10,
            right: 10,
          ),
          helperText: ' ',
          hintText: hint,
          isDense: true,
          errorMaxLines: errorMaxLines,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      );
}
