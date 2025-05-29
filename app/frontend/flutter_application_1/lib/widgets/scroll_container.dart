import 'package:flutter/material.dart';

class ScrollContainer extends StatelessWidget {
  final Widget child;
  const ScrollContainer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: child,
    );
  }
}
