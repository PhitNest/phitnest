import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_core/core.dart';

final class StyledIndicator extends StatelessWidget {
  final int count;
  final Widget child;
  final Size offset;

  const StyledIndicator({
    Key? key,
    required this.child,
    required this.count,
    required this.offset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          child,
          Visibility(
            visible: count > 0,
            child: Positioned(
              right: offset.width,
              top: offset.height,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 9.w,
                  vertical: 2.5.h,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(32.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  count.toString(),
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}
