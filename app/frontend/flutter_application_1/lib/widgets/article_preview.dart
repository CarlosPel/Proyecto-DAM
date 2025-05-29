import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ArticlePreview extends StatelessWidget {
  final String title;
  final String? source;
  final String? datetime;
  
  const ArticlePreview(
      {super.key, required this.title, this.source, this.datetime});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMMd('es_ES')
        .add_Hm()
        .format(datetime != null ? DateTime.parse(datetime!) : DateTime.now());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Georgia',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Text(
              source ?? 'Fuente desconocida',
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
            const Spacer(),
            Text(
              formattedDate,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }
}
