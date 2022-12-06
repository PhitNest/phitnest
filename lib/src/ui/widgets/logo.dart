import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LogoWidget extends StatelessWidget {
  static const String kLogoPath = 'assets/images/logo.svg';

  final double? width, height;

  const LogoWidget({
    this.width,
    this.height,
  }) : super();

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
        kLogoPath,
        width: width,
        height: height,
      );
}
