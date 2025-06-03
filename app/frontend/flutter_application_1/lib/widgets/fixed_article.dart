import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/article.dart';
import 'package:flutter_application_1/widgets/article_card.dart';
import 'package:flutter_application_1/widgets/article_container.dart';
import 'package:flutter_application_1/widgets/article_preview.dart';

class FixedArticle extends StatelessWidget {
  final Article article;

  const FixedArticle(this.article, {super.key});

  @override
  Widget build(BuildContext context) {
    return ArticleContainer(
      articleCard(
        child: Column(children: [
          ArticlePreview(
            title: article.title,
            source: article.source,
            datetime: article.datetime,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              article.snippet!,
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
