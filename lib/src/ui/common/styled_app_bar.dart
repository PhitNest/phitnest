import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StyledAppBar extends AppBar {
  static double get backButtonWidth => 64.w;

  StyledAppBar(
      {required BuildContext context,
      bool systemOverlayDark = true,
      double? height,
      String? text,
      Widget? backButton})
      : super(
            systemOverlayStyle: systemOverlayDark
                ? SystemUiOverlayStyle.dark
                : SystemUiOverlayStyle.light,
            toolbarHeight: height ?? 60.w,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            title: Padding(
                padding: EdgeInsets.only(top: 12.h, right: backButtonWidth),
                child: Center(
                    child: Text(text ?? "",
                        style: Theme.of(context).textTheme.headlineMedium))),
            leadingWidth: backButtonWidth,
            leading: backButton);
}
