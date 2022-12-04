import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final FormFieldValidator? validator;
  final TextInputAction? inputAction;
  final VoidCallback? onTap;

  const TextInputField({
    Key? key,
    this.controller,
    this.hint,
    this.validator,
    this.onTap,
    this.inputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TextFormField(
        onTap: onTap,
        textInputAction: inputAction,
        controller: controller,
        validator: validator,
        style: Theme.of(context).textTheme.labelMedium,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
          helperText: ' ',
          hintText: hint,
          hintStyle: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: Color(0xFF999999)),
          border: MaterialStateUnderlineInputBorder.resolveWith(
            (state) => UnderlineInputBorder(
              borderSide: BorderSide(
                color: state.contains(MaterialState.focused)
                    ? Colors.black
                    : Color(0xFFDADADA),
              ),
            ),
          ),
        ),
      );
}
