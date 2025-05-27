import 'package:flutter/material.dart';
import 'package:flutter_application_1/utilities/fold_painter.dart';
import 'package:flutter_application_1/widgets/flod_clipper.dart';

class NewspaperWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback onFoldTap;

  const NewspaperWrapper({
    super.key,
    required this.child,
    required this.onFoldTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1) El “papel” con recorte
        ClipPath(
          clipper: FoldClipper(),
          child: Container(
            color: const Color(0xFFFAF5E5), // tono papel antiguo
          ),
        ),

        // 2) Tu contenido real
        Positioned.fill(child: child),

        // 3) El doblez dibujado
        Positioned(
          top: 0,
          right: 0,
          child: CustomPaint(
            size: const Size(60, 60),
            painter: FoldPainter(),
          ),
        ),

        // 4) Zona táctil sobre el doblez
        Positioned(
          top: 0,
          right: 0,
          width: 60,
          height: 60,
          child: GestureDetector(
            onTap: onFoldTap,
            behavior: HitTestBehavior.translucent,
          ),
        ),
      ],
    );
  }
}
