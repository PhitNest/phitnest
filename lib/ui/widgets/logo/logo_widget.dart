import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class LogoWidget extends StatelessWidget {
  final double scale;
  final Color? color;

  const LogoWidget({Key? key, this.scale = 1, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) => Image.asset(
        LOGO_PATH,
        scale: 1 / scale,
        fit: BoxFit.cover,
        color: color,
      );
}
