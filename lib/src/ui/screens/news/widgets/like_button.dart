import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final Function() onPressedLiked;
  final bool liked;

  LikeButton({required this.onPressedLiked, required this.liked}) : super();

  @override
  Widget build(BuildContext context) => InkWell(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        onTap: onPressedLiked,
        child: Container(
            width: 23,
            height: 20,
            child: Image.asset(
              liked
                  ? 'assets/images/favourite_icon_red.png'
                  : 'assets/images/favourite_icon_white.png',
              fit: BoxFit.contain,
            )),
      );
}
