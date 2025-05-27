import 'package:flutter/material.dart';

class FoldClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Tamaño del pliegue
    final foldSize = 60.0;
    return Path()
      ..lineTo(size.width - foldSize, 0)
      ..lineTo(size.width, foldSize)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
