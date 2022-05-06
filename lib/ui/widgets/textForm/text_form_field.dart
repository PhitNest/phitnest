import 'package:flutter/material.dart';

import '../../../../constants/constants.dart';
import 'text_form_style_decoration.dart';

class TextInputFormField extends StatelessWidget {
  final String hint;

  final Function(String? text) onSaved;

  final Function()? onSubmit;

  final String? Function(String? text) validator;

  const TextInputFormField({
    Key? key,
    required this.hint,
    required this.validator,
    required this.onSaved,
    this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        textAlignVertical: TextAlignVertical.center,
        textInputAction:
            onSubmit == null ? TextInputAction.next : TextInputAction.done,
        onFieldSubmitted: (_) => onSubmit == null ? {} : onSubmit!(),
        obscureText: true,
        validator: validator,
        onSaved: onSaved,
        style: TextStyle(fontSize: 18.0),
        cursorColor: Color(COLOR_PRIMARY),
        decoration: TextFormStyleDecoration(hint: hint));
  }
}
