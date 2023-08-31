import 'package:flutter/material.dart';

final class Loader extends StatelessWidget {
  const Loader({super.key}) : super();

  @override
  Widget build(BuildContext context) =>
      Center(child: CircularProgressIndicator());
}
