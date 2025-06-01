import 'package:flutter/material.dart';

class LeadingButton extends StatelessWidget {
  const LeadingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back_ios_new, size: 28),
        onPressed: () => Navigator.of(context).pop(),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          foregroundColor: WidgetStateProperty.all(Colors.black)
        ));
  }
}
