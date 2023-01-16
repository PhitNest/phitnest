import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StyledPageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const StyledPageIndicator({
    Key? key,
    required this.currentPage,
    required this.totalPages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          totalPages,
          (index) => Container(
            width: 8.w,
            height: 8.w,
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              color: currentPage >= index ? Colors.black : Colors.grey.shade400,
              borderRadius: BorderRadius.circular(4.w),
            ),
          ),
        ),
      );
}
