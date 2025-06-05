import 'package:flutter/material.dart';

class ScrollContainer extends StatelessWidget {
  final Widget child;
  const ScrollContainer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Theme.of(context).colorScheme.secondary;

    return Container(
      color: backgroundColor,
      child: child,
    );
  }
}
