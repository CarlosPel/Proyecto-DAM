import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/article.dart';
import 'package:flutter_application_1/screens/create_post_screen.dart';

class ArticleWidget extends StatefulWidget {
  final Article article;
  final bool isExpanded;
  final VoidCallback onTap;

  const ArticleWidget(
      {super.key,
      required this.article,
      required this.onTap,
      required this.isExpanded});

  @override
  ArticleWidgetState createState() => ArticleWidgetState();
}

class ArticleWidgetState extends State<ArticleWidget> {
  @override
  Widget build(BuildContext context) {
    final Article article = widget.article;

    return Card(
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      article.title,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  /*Icon(
                    widget.isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.black,
                  ),*/
                ],
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      if (article.snippet != null) ...[Text(
                        article.snippet!,
                        style: const TextStyle(color: Colors.black),
                      )],
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CreatePostScreen(article: article),
                                ),
                              );
                            },
                            child: const Text('Post'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                crossFadeState: widget.isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
