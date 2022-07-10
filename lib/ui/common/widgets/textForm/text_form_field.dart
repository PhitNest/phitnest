import 'package:flutter/material.dart';

import '../../textStyles/text_styles.dart';
import 'text_form_decoration.dart';

/// This is a text form field widget
class TextInputFormField extends StatelessWidget {
  final String hint;
  final TextStyle? hintStyle;
  final Function(String? text)? onSaved;
  final Function(String text)? onSubmit;
  final String? Function(String? text) validator;
  final TextEditingController? controller;
  final bool hide;
  final EdgeInsets padding;
  final TextInputAction? inputAction;
  final TextInputType? inputType;
  final FocusNode? focusNode;

  const TextInputFormField({
    required Key key,
    required this.hint,
    required this.validator,
    this.hintStyle,
    this.onSaved,
    this.controller,
    this.inputType,
    this.inputAction,
    this.focusNode,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
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
          focusNode: focusNode,
          textInputAction: inputAction ??
              (onSubmit == null ? TextInputAction.next : TextInputAction.done),
          onFieldSubmitted: onSubmit,
          obscureText: hide,
          keyboardType: inputType,
          validator: validator,
          onSaved: onSaved,
          controller: controller ?? TextEditingController(),
          style: BodyTextStyle(size: TextSize.LARGE),
          cursorColor: Colors.black,
          decoration:
              TextFormStyleDecoration(hint: hint, hintStyle: hintStyle)));
}
