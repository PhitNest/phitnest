import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StyledNavBar extends StatelessWidget {
  static const double kHeight = 80;

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

  Widget createButton(BuildContext context, String text, Function() onPressed, int index) =>
    TextButton(style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)), child: Text(text, style: index == pageIndex
      ? Theme.of(context).textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          )
      : Theme.of(context).textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.bold,)), onPressed: navigationEnabled ? onPressed : null);
  

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
            createButton(context, 'NEWS', (){
              print('NEWS');
            }, 0),
            createButton(context, 'EXPLORE', (){
              print('EXPLORE');
            }, 1),
            GestureDetector(
              onTapDown: onTapDownLogo,
              onTapUp: onTapUpLogo,
              child: Image.asset(
                kColoredLogoPath,
                width: 50.0.w,
                height: 38.62.h,
              ),
            ),
            createButton(context, 'CHAT', (){
              print('CHAT');
            }, 2),
            createButton(context, 'OPTIONS', (){
              print('OPTIONS');
            }, 3),
          ],
        ),
      ),
    );
  }
}
