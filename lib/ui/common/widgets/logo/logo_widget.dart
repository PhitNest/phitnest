import 'package:flutter/material.dart';
import '../widgets.dart';

const LOGO_PATH = 'assets/images/app_logo.png';
const LOGO_PATH_WITH_TEXT = 'assets/images/app_logo_text.png';

class LogoWidget extends ImageWidget {
  final double scale;
  final Color? color;
  final bool showText;
  final EdgeInsets padding;

  const LogoWidget(
      {this.padding = EdgeInsets.zero,
      this.showText = false,
      this.scale = 1,
      this.color})
      : super(
            padding: padding,
            path: showText ? LOGO_PATH_WITH_TEXT : LOGO_PATH,
            scale: scale,
            color: color);
}
