import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/post.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostWidget extends StatelessWidget {
  final Post post;
  final bool isExpanded; // lo mantenemos por compatibilidad
  final VoidCallback onTap;

  const PostWidget({
    super.key,
    required this.post,
    required this.onTap,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    final postDate = DateTime.tryParse(post.datetime ?? '');
    final relativeTime = postDate != null
        ? timeago.format(postDate, locale: 'es')
        : 'Fecha desconocida';

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.postScreen,
        arguments: {
          'post': post,
          'article': post.article,
        },
      ),
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: const Color(0xFFFDF6ED), // tono editorial
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Text(
                post.title ?? '',
                style: const TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Extracto del contenido
              Text(
                (post.content).length > 160
                    ? '${post.content.substring(0, 160)}...'
                    : post.content,
                style: const TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              // Autor y tiempo
              Row(
                children: [
                  // Text(
                  //   post.user ?? 'Autor desconocido',
                  //   style: TextStyle(
                  //     fontSize: 13,
                  //     fontStyle: FontStyle.italic,
                  //     color: Colors.grey[700],
                  //   ),
                  // ),
                  const Spacer(),
                  Text(
                    relativeTime,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
