import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LikeButton extends StatelessWidget {
  final Function() onPressedLiked;
  final bool liked;

  LikeButton({required this.onPressedLiked, required this.liked}) : super();

  @override
  Widget build(BuildContext context) => InkWell(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        onTap: onPressedLiked,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 9),
            child: Container(
                width: 23.w,
                height: 20.h,
                child: Image.asset(
                  liked
                      ? 'assets/images/favourite_icon_red.png'
                      : 'assets/images/favourite_icon_white.png',
                  fit: BoxFit.contain,
                ))),
      );
}
