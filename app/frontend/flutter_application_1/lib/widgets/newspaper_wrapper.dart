import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_data.dart';
import 'package:flutter_application_1/utilities/fold_painter.dart';

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
    final foldSize = AppData.foldSize;
    
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      color: const Color.fromARGB(255, 255, 255, 255),
      elevation: 4,
      child: Stack(
        children: [
          // 2) Tu contenido real
          Positioned.fill(child: child),
      
          // 3) El doblez dibujado (asegúrate de que esté después del contenido)
          Positioned(
            bottom: 0,
            right: 0,
            child: CustomPaint(
              size: Size(foldSize, foldSize),
              painter: FoldPainter(),
            ),
          ),
      
          // 4) Zona táctil sobre el doblez
          Positioned(
            bottom: 0,
            right: 0,
            width: foldSize,
            height: foldSize,
            child: GestureDetector(
              onTap: onFoldTap,
              behavior: HitTestBehavior.translucent,
            ),
          ),
        ],
      ),
    );
  }
}
