import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String path;
  final double scale;
  final Color? color;
  final EdgeInsets padding;

  const ImageWidget(
      {required this.path,
      this.padding = EdgeInsets.zero,
      this.scale = 1,
      this.color})
      : super();

  @override
  Widget build(BuildContext context) => Container(
      padding: padding,
      child: Image.asset(
        path,
        scale: 1 / scale,
        fit: BoxFit.cover,
        color: color,
      ));
}
