import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_data.dart';
import 'package:flutter_application_1/widgets/fold_painter.dart';
import 'package:turn_page_transition/turn_page_transition.dart';

class NewspaperWrapper extends StatelessWidget {
  final Widget child;
  final StatefulWidget screen;
  final BuildContext previusScreen;
  final TurnDirection turnDirection;
  final Color? backcolor;

  const NewspaperWrapper({
    super.key,
    required this.child,
    required this.screen,
    required this.previusScreen,
    this.turnDirection = TurnDirection.rightToLeft,
    this.backcolor,
  });

  void pageTurnNavigate() {
    Navigator.of(previusScreen).push(
      TurnPageRoute(
        overleafColor: Colors.grey,
        animationTransitionPoint: 0.5,
        transitionDuration: const Duration(milliseconds: AppData.pageTurnTime),
        reverseTransitionDuration:
            const Duration(milliseconds: AppData.pageTurnTime),
        direction: turnDirection,
        builder: (context) => screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foldSize = AppData.foldSize;
    Color backgroundColor = Theme.of(context).colorScheme.secondary;
    if (backcolor != null) backgroundColor = backcolor!;

    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      color: backgroundColor,
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
              painter: FoldPainter(backgroundColor),
            ),
          ),

          // 4) Zona táctil sobre el doblez
          Positioned(
            bottom: 0,
            right: 0,
            width: foldSize,
            height: foldSize,
            child: GestureDetector(
              onTap: pageTurnNavigate,
              behavior: HitTestBehavior.translucent,
            ),
          ),
        ],
      ),
    );
  }
}
