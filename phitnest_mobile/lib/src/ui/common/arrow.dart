import 'package:flutter/material.dart';

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color.fromARGB(255, 193, 28, 28)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    Path path = Path();

    path
      ..moveTo(0, size.height / 2)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width - size.height / 2, size.height)
      ..moveTo(size.width, size.height / 2)
      ..lineTo(size.width - size.height / 2, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Arrow extends StatelessWidget {
  final double height;
  final double width;

  const Arrow({required this.width, required this.height}) : super();

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: ArrowPainter(),
        size: Size(width, height),
      );
}
