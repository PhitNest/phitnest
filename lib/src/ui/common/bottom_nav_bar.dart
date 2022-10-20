import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StyledNavBar extends StatelessWidget {
  static const double kHeight = 80;

  final int pageIndex;
  final Function(TapDownDetails? details) onTapDownLogo;
  final Function(TapUpDetails? details) onTapUpLogo;

  TextStyle getTextStyle(BuildContext context, int index) => index == pageIndex
      ? Theme.of(context).textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          )
      : Theme.of(context).textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.bold,
          );

  static const String kColoredLogoPath = 'assets/images/logo_color.png';

  const StyledNavBar(
      {Key? key,
      required this.pageIndex,
      required this.onTapDownLogo,
      required this.onTapUpLogo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 8.5,
            spreadRadius: 0.0,
            color: Colors.black,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Ink(
        width: double.infinity,
        height: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'NEWS',
              style: getTextStyle(context, 0),
            ),
            Text(
              'EXPLORE',
              style: getTextStyle(context, 1),
            ),
            GestureDetector(
              onTapDown: onTapDownLogo,
              onTapUp: onTapUpLogo,
              child: Image.asset(
                kColoredLogoPath,
                width: 50.0.w,
                height: 38.62.h,
              ),
            ),
            Text(
              'CHAT',
              style: getTextStyle(context, 2),
            ),
            Text(
              'OPTIONS',
              style: getTextStyle(context, 3),
            ),
          ],
        ),
      ),
    );
  }
}
