import 'package:flutter/material.dart';

class OptionsScreen extends StatelessWidget {
  final Image pfp;

  const OptionsScreen({
    super.key,
    required this.pfp,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: pfp,
        ),
      );
}
