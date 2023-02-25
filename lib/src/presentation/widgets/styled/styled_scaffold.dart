import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StyledScaffold extends StatelessWidget {
  final Widget body;
  final Widget? bottomNavigationBar;
  final bool safeArea;

  const StyledScaffold({
    Key? key,
    required this.body,
    this.bottomNavigationBar,
    this.safeArea = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: safeArea ? SafeArea(child: body) : body,
          bottomNavigationBar: bottomNavigationBar,
        ),
      );
}
