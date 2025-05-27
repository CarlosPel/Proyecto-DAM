import 'package:flutter/material.dart';

class FoldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final foldSize = 60.0;
    final paint = Paint()..color = Colors.grey.shade300;
    final path = Path()
      ..moveTo(size.width - foldSize, 0)
      ..lineTo(size.width, foldSize)
      ..lineTo(size.width - foldSize, foldSize)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
