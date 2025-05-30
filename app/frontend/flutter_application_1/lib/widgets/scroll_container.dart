import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_theme.dart';

class ScrollContainer extends StatelessWidget {
  final Widget child;
  const ScrollContainer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.newsPaperBackgroundColor,
      child: child,
    );
  }
}
