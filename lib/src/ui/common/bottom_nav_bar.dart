import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../screens/screens.dart';
import 'no_animation_page_route.dart';

class StyledNavBar extends StatelessWidget {
  static double get kHeight => Platform.isIOS ? 85.h : 66.h;

  final int pageIndex;
  final Function(TapDownDetails? details) onTapDownLogo;
  final Function(TapUpDetails? details) onTapUpLogo;
  final bool navigationEnabled;

  static const String kColoredLogoPath = 'assets/images/logo_color.png';

  const StyledNavBar(
      {Key? key,
      required this.navigationEnabled,
      required this.pageIndex,
      required this.onTapDownLogo,
      required this.onTapUpLogo})
      : super(key: key);

  Widget createButton(
          BuildContext context, String text, Function() onPressed, int index) =>
      TextButton(
          style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.only(right: 15.w)),
              overlayColor: MaterialStateProperty.all(Colors.transparent)),
          child: Text(text,
              style: index == pageIndex
                  ? Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.black)
                  : Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.bold)),
          onPressed:
              navigationEnabled && index != pageIndex ? onPressed : null);

  @override
  Widget build(BuildContext context) => Container(
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
              15.horizontalSpace,
              createButton(
                  context,
                  'NEWS',
                  () => Navigator.pushAndRemoveUntil(
                      context,
                      NoAnimationMaterialPageRoute(
                          builder: (context) => NewsProvider()),
                      (route) => false),
                  0),
              createButton(
                  context,
                  'EXPLORE',
                  () => Navigator.pushAndRemoveUntil(
                      context,
                      NoAnimationMaterialPageRoute(
                          builder: (context) => ExploreProvider()),
                      (route) => false),
                  1),
              GestureDetector(
                onTapDown: onTapDownLogo,
                onTapUp: onTapUpLogo,
                child: Image.asset(
                  kColoredLogoPath,
                  width: 38.62.w,
                ),
              ),
              createButton(
                  context,
                  'CHAT',
                  () => Navigator.pushAndRemoveUntil(
                      context,
                      NoAnimationMaterialPageRoute(
                          builder: (context) => ChatProvider()),
                      (route) => false),
                  2),
              createButton(
                  context,
                  'OPTIONS',
                  () => Navigator.pushAndRemoveUntil(
                      context,
                      NoAnimationMaterialPageRoute(
                          builder: (context) => OptionsProvider()),
                      (route) => false),
                  3),
            ],
          ),
        ),
      );
}
