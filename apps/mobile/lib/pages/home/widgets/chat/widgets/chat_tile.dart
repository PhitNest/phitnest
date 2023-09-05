import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:ui/ui.dart';

class ChatTile extends StatelessWidget {
  final void Function() onTap;
  final String name;
  final String message;

  const ChatTile({
    super.key,
    required this.name,
    required this.message,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            14.verticalSpace,
            GradientText(
              name,
              style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.w700),
              gradientType: GradientType.linear,
              gradientDirection: GradientDirection.ttb,
              colors: const [
                Color(0xFF5E5CE6),
                Color(0xFFBF5AF2),
              ],
            ),
            Text(
              message,
              style: theme.textTheme.bodySmall!.copyWith(
                fontSize: 14.sp,
              ),
            ),
            14.verticalSpace,
            const Divider(
              color: Color(0xFFE5E5EA),
              thickness: 1,
            ),
          ],
        ),
      );
}
