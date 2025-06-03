import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_theme.dart';

class ArticleContainer extends StatelessWidget {
  final Widget secondWidget;

  const ArticleContainer(this.secondWidget, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.newsPaperBackgroundColor,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'ARTICULO',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ),
        secondWidget,
      ]),
    );
  }
}
