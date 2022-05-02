import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DisplayUtils {
  static bool isDarkMode = false;

  static void initialize(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
  }

  static Widget displayCircleImage(String picUrl, double size, hasBorder) =>
      CachedNetworkImage(
          imageBuilder: (context, imageProvider) =>
              _getCircularImageProvider(imageProvider, size, false),
          imageUrl: picUrl,
          placeholder: (context, url) =>
              _getPlaceholderOrErrorImage(size, hasBorder),
          errorWidget: (context, url, error) =>
              _getPlaceholderOrErrorImage(size, hasBorder));

  static Widget _getPlaceholderOrErrorImage(double size, hasBorder) =>
      Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xff7c94b6),
          borderRadius: BorderRadius.all(Radius.circular(size / 2)),
          border: Border.all(
            color: Colors.white,
            width: hasBorder ? 2.0 : 0.0,
          ),
        ),
        child: ClipOval(
            child: Image.asset(
          'assets/images/placeholder.jpg',
          fit: BoxFit.cover,
          height: size,
          width: size,
        )),
      );

  static Widget _getCircularImageProvider(
      ImageProvider provider, double size, bool hasBorder) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xff7c94b6),
        borderRadius: BorderRadius.all(Radius.circular(size / 2)),
        border: Border.all(
          color: Colors.white,
          width: hasBorder ? 2.0 : 0.0,
        ),
      ),
      child: ClipOval(
          child: FadeInImage(
              fit: BoxFit.cover,
              placeholder: Image.asset(
                'assets/images/placeholder.jpg',
                fit: BoxFit.cover,
                height: size,
                width: size,
              ).image,
              image: provider)),
    );
  }
}
