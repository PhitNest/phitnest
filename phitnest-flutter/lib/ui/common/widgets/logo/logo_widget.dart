import 'package:flutter/material.dart';
import '../widgets.dart';

const LOGO_PATH_LIGHT = 'assets/images/app_logo_light.png';
const LOGO_PATH_WITH_TEXT_LIGHT = 'assets/images/app_logo_text_light.png';
const LOGO_PATH_DARK = 'assets/images/app_logo_dark.png';

class LogoWidget extends ImageWidget {
  final double scale;
  final Color? color;
  final bool showText;
  final bool light;
  final EdgeInsets padding;

  const LogoWidget(
      {this.padding = EdgeInsets.zero,
      this.showText = false,
      this.scale = 1,
      this.light = false,
      this.color})
      : super(
            padding: padding,
            path: light
                ? (showText ? LOGO_PATH_WITH_TEXT_LIGHT : LOGO_PATH_LIGHT)
                : LOGO_PATH_DARK,
            scale: scale,
            color: color);
}
