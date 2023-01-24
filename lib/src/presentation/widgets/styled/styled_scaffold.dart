import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StyledScaffold extends StatelessWidget {
  final Widget body;
  final Widget? bottomNavigationBar;

  const StyledScaffold({
    Key? key,
    required this.body,
    this.bottomNavigationBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: body,
          bottomNavigationBar: bottomNavigationBar,
        ),
      );
}
