import 'package:flutter/material.dart';

class ArticleContainer extends StatelessWidget {
  final Widget secondWidget;

  const ArticleContainer(this.secondWidget, {super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme titleStyle = Theme.of(context).textTheme;

    return Card(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'ARTICULO',
            style: titleStyle.titleLarge,
          ),
        ),
        secondWidget,
      ]),
    );
  }
}
