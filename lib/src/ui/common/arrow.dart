import 'package:flutter/material.dart';

class ArrowPainter extends CustomPainter {
  final Color color;
  final bool left;

  const ArrowPainter({required this.color, required this.left}) : super();

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    Path path = Path();

    if (left) {
      path
        ..moveTo(size.width, size.height / 2)
        ..lineTo(0, size.height / 2)
        ..lineTo(0 + size.height / 2, size.height)
        ..moveTo(0, size.height / 2)
        ..lineTo(0 + size.height / 2, 0)
        ..close();
    } else {
      path
        ..moveTo(0, size.height / 2)
        ..lineTo(size.width, size.height / 2)
        ..lineTo(size.width - size.height / 2, size.height)
        ..moveTo(size.width, size.height / 2)
        ..lineTo(size.width - size.height / 2, 0)
        ..close();
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Arrow extends StatelessWidget {
  final double width, height;
  final Color color;
  final bool left;

  const Arrow(
      {required this.width,
      required this.height,
      required this.color,
      this.left = false})
      : super();

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: ArrowPainter(color: color, left: left),
        size: Size(width, height),
      );
}
