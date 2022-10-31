import 'package:flutter/material.dart';

class FavouriteIconFunction extends StatelessWidget {
  final Function? onPressedLiked;
  final int status;

  FavouriteIconFunction({required this.onPressedLiked, required this.status})
      : super();

  String get getIconUrl {
    switch (status) {
      case 1:
        return 'assets/images/favourite_icon_white.png';
      case 2:
        return 'assets/images/favourite_icon_red.png';
    }

    return ('');
  }

  @override
  Widget build(BuildContext context) {
    return status != 3
        ? InkWell(
            onTap: () => onPressedLiked,
            child: Container(
                width: 23,
                height: 20,
                child: Image.asset(
                  getIconUrl,
                  fit: BoxFit.contain,
                )),
          )
        : Text('');
  }
}
