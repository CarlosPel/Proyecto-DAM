import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_data.dart';

class FoldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const foldSize = AppData.foldSize;

    // Hoja de atras
    final paint2 = Paint()..color = const Color.fromARGB(255, 119, 110, 110);
    final path2 = Path()
      ..moveTo(size.width - foldSize, size.height)
      ..lineTo(size.width - foldSize * 0.45, size.height - foldSize * 0.45)
      ..lineTo(size.width, size.height - foldSize)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path2, paint2);

    // Sombra del doblez
    const shadDist = 20;
    final paint3 = Paint()..color = const Color.fromARGB(136, 0, 0, 0);
    final path3 = Path()
      ..moveTo(size.width - foldSize, size.height)
      ..lineTo(size.width - foldSize * 0.85 - shadDist * 0.5,
          size.height - foldSize * 0.20)
      ..lineTo(size.width - foldSize * 0.80 - shadDist * 0.6,
          size.height - foldSize * 0.5)
      ..lineTo(size.width - foldSize * 0.85 - shadDist * 0.7,
          size.height - foldSize * 0.80)
      ..lineTo(size.width - foldSize * 0.5, size.height - foldSize * 0.76)
      ..lineTo(size.width - foldSize * 0.2, size.height - foldSize * 0.70)
      ..lineTo(size.width, size.height - foldSize)
      ..lineTo(size.width - foldSize * 0.10, size.height - foldSize * 0.80)
      ..lineTo(size.width - foldSize * 0.416, size.height - foldSize * 0.41)
      ..lineTo(size.width - foldSize * 0.80, size.height - foldSize * 0.10)
      ..close();

    canvas.drawPath(path3, paint3);

    // Doblez de la hoja
    final Paint paintFill_0 = Paint()
      ..color = const Color.fromARGB(255, 231, 222, 222)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    final Path path_0 = Path()
      ..moveTo(size.width - foldSize, size.height)
      ..lineTo(size.width - foldSize * 0.85, size.height - foldSize * 0.20)
      ..lineTo(size.width - foldSize * 0.80, size.height - foldSize * 0.5)
      ..lineTo(size.width - foldSize * 0.85, size.height - foldSize * 0.85)
      ..lineTo(size.width - foldSize * 0.5, size.height - foldSize * 0.8)
      ..lineTo(size.width - foldSize * 0.2, size.height - foldSize * 0.85)
      ..lineTo(size.width, size.height - foldSize)
      ..lineTo(size.width - foldSize * 0.10, size.height - foldSize * 0.80)
      ..lineTo(size.width - foldSize * 0.416, size.height - foldSize * 0.41)
      ..lineTo(size.width - foldSize * 0.80, size.height - foldSize * 0.10)
      ..close();

    canvas.drawPath(path_0, paintFill_0);

    // Borde del doblez de la hoja
    final Paint paintBorder = Paint()
      ..color = Colors.black54 // o el color que prefieras
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawPath(path_0, paintBorder);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
