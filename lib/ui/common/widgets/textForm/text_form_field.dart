import 'package:device/device.dart';
import 'package:flutter/material.dart';

import '../../textStyles/text_styles.dart';
import 'text_form_decoration.dart';

/// This is a text form field widget
class TextInputFormField extends StatelessWidget {
  final String hint;
  final TextStyle? hintStyle;
  final Function(String? text)? onSaved;
  final Function()? onSubmit;
  final String? Function(String? text) validator;
  final TextEditingController? controller;
  final bool hide;
  final EdgeInsets padding;
  final TextInputType? inputType;

  const TextInputFormField({
    required Key key,
    required this.hint,
    required this.validator,
    this.hintStyle,
    this.onSaved,
    this.controller,
    this.inputType,
    this.padding = const EdgeInsets.only(top: 16, left: 8, right: 8),
    this.hide = false,
    this.onSubmit,
  }) : super();

  @override
  Widget build(BuildContext context) => Container(
      constraints: const BoxConstraints(minWidth: double.infinity),
      padding: padding,
      child: TextFormField(
          key: key,
          textAlignVertical: TextAlignVertical.center,
          textInputAction:
              onSubmit == null ? TextInputAction.next : TextInputAction.done,
          onFieldSubmitted: (_) => onSubmit == null ? {} : onSubmit!(),
          obscureText: hide,
          keyboardType: inputType,
          validator: validator,
          onSaved: onSaved,
          controller: controller ?? TextEditingController(),
          style: BodyTextStyle(size: TextSize.LARGE),
          cursorColor: primaryColor,
          decoration:
              TextFormStyleDecoration(hint: hint, hintStyle: hintStyle)));
}
