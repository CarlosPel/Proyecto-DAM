import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/article.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:flutter_application_1/data/app_theme.dart';
import 'package:flutter_application_1/widgets/article_preview.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final bool isExpanded;
  final VoidCallback onTap;

  const ArticleCard({
    super.key,
    required this.article,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: articleCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ArticlePreview(
                title: article.title,
                source: article.source,
                datetime: article.datetime),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 500),
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (article.snippet != null)
                      Text(
                        article.snippet!,
                        style: const TextStyle(
                          fontFamily: 'Times New Roman',
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    const SizedBox(height: 12),
                    if (article.imgUrl != null && article.imgUrl!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          article.imgUrl!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 180,
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            if (article.link != null) {
                              launchUrl(Uri.parse(article.link!));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Página web no disponible')),
                              );
                            }
                          },
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('Ir al artículo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        Spacer(),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.createPostScreen,
                              arguments: {
                                'article': article,
                              },
                            );
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Opinar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ],
        ),
      ),
    );
  }
}

Widget articleCard({required Column child}) {
  return Card(
    color: AppTheme.articleBackgroundColor,
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(padding: const EdgeInsets.all(16), child: child));
}
