import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme.dart';

class SearchBox extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;

  const SearchBox({
    Key? key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.onTap,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 343.w,
        height: 32.h,
        child: GestureDetector(
          onTap: onTap,
          child: TextField(
            focusNode: focusNode,
            textAlignVertical: TextAlignVertical.center,
            style: theme.textTheme.labelMedium,
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 16.w),
              hintText: hintText,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(8)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(8)),
              hintStyle: theme.textTheme.labelMedium!.copyWith(
                color: Color(0xFF999999),
              ),
            ),
          ),
        ),
      );
}
