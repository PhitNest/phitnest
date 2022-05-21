import 'package:flutter/material.dart';

const LOGO_PATH = 'assets/images/app_logo.png';
const LOGO_PATH_WITH_TEXT = 'assets/images/app_logo_text.png';

class LogoWidget extends StatelessWidget {
  final double scale;
  final Color? color;
  final bool showText;
  final EdgeInsets padding;

  const LogoWidget(
      {Key? key,
      this.padding = EdgeInsets.zero,
      this.showText = false,
      this.scale = 1,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
      padding: padding,
      child: Image.asset(
        showText ? LOGO_PATH_WITH_TEXT : LOGO_PATH,
        width: 216 * scale,
        height: 216 * scale,
        fit: BoxFit.cover,
        color: color,
      ));
}
