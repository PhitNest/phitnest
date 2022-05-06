import 'package:display/display.dart';
import 'package:flutter/material.dart';

import 'text_form_style_decoration.dart';

/// This is a text form field widget
class TextInputFormField extends StatelessWidget {
  final String hint;
  final Function(String? text) onSaved;
  final Function()? onSubmit;
  final String? Function(String? text) validator;
  final TextEditingController? controller;
  final bool hide;
  final TextInputType? inputType;

  const TextInputFormField({
    Key? key,
    required this.hint,
    required this.validator,
    required this.onSaved,
    this.controller,
    this.inputType,
    this.hide = false,
    this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TextFormField(
      textAlignVertical: TextAlignVertical.center,
      textInputAction:
          onSubmit == null ? TextInputAction.next : TextInputAction.done,
      onFieldSubmitted: (_) => onSubmit == null ? {} : onSubmit!(),
      obscureText: hide,
      keyboardType: inputType,
      validator: validator,
      onSaved: onSaved,
      controller: controller ?? TextEditingController(),
      style: TextStyle(fontSize: 18.0),
      cursorColor: primaryColor,
      decoration: TextFormStyleDecoration(hint: hint));
}
