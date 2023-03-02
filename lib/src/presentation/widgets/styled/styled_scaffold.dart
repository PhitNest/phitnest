import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StyledScaffold extends StatelessWidget {
  final Widget body;
  final bool safeArea;
  final bool lightMode;

  const StyledScaffold({
    Key? key,
    required this.body,
    this.safeArea = true,
    this.lightMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value:
            lightMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: safeArea
              ? SafeArea(
                  child: body,
                  left: false,
                  right: false,
                  bottom: false,
                )
              : body,
        ),
      );
}
