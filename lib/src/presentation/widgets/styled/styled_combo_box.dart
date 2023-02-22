import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constants/constants.dart';
import '../../../common/theme.dart';

class StyledComboBox<ItemType> extends StatelessWidget {
  final List<ItemType> items;
  final String? Function(ItemType item) labelBuilder;
  final ValueChanged<ItemType> onChanged;
  final ItemType? initialValue;
  final String? hint;
  final double? width;
  final double? height;

  const StyledComboBox({
    Key? key,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
    this.hint,
    this.initialValue,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        height: height,
        child: DropdownButtonFormField(
          hint: hint != null
              ? Text(
                  hint!,
                  style: theme.textTheme.labelMedium,
                )
              : null,
          value: initialValue,
          borderRadius: BorderRadius.circular(8.r),
          icon: Image.asset(
            Assets.dropDownButton.path,
            width: 16.w,
            height: 16.h,
          ),
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 8.w, horizontal: 16.w),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: Colors.black,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    labelBuilder(item) ?? "",
                    style: theme.textTheme.labelMedium,
                  ),
                ),
              )
              .toList(),
          onChanged: (ItemType? item) => onChanged(item!),
        ),
      );
}
