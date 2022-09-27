import 'package:flutter/material.dart';

import 'widgets.dart';

class BackArrowButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => IconButton(
      onPressed: () => Navigator.maybePop(context),
      icon: Arrow(
        width: 40,
        height: 12,
        left: true,
        color: Colors.black,
      ));
}
