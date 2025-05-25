import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/article.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ArticleWidget extends StatelessWidget {
  final Article article;
  final bool isExpanded;
  final VoidCallback onTap;

  const ArticleWidget({
    super.key,
    required this.article,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeDateFormatting('es_ES', null),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final formattedDate = DateFormat.yMMMMd('es_ES').add_Hm().format(DateTime.parse(article.datetime!));

        return GestureDetector(
          onTap: onTap,
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (article.imgUrl != null && article.imgUrl!.isNotEmpty)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      article.imgUrl!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
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
                            article.source ?? 'Fuente desconocida',
                            style: TextStyle(color: Colors.grey[700], fontSize: 13),
                          ),
                          const Spacer(),
                          Text(
                            formattedDate,
                            style: TextStyle(color: Colors.grey[600], fontSize: 13),
                          ),
                        ],
                      ),
                      AnimatedCrossFade(
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
                                    fontFamily: 'Georgia',
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton.icon(
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
                                  label: const Text('Postear'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black87,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        crossFadeState: isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 200),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
