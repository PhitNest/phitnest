import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StyledAppBar extends StatelessWidget {
  static double get backButtonWidth => 64.w;

  final bool systemOverlayDark;
  final String? text;
  final Widget? backButton;

  const StyledAppBar({
    Key? key,
    this.systemOverlayDark = true,
    this.text,
    this.backButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AppBar(
        systemOverlayStyle: systemOverlayDark
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
        toolbarHeight: 60.h,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Padding(
          padding: EdgeInsets.only(
            top: 12.h,
            right: backButtonWidth,
          ),
          child: Center(
            child: Text(
              text ?? "",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
        leadingWidth: backButtonWidth,
        leading: backButton,
      );
}
