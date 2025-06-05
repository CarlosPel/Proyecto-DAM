import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/post.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatelessWidget {
  final Post post;
  final bool isPreview;
  // final bool isExpanded; // lo mantenemos por compatibilidad
  final VoidCallback onTap;

  const PostCard({
    super.key,
    required this.post,
    this.isPreview = true,
    required this.onTap,
    //required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Theme.of(context).colorScheme.surface;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        color: backgroundColor,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Text(
                post.title!,
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              // Extracto del contenido
              Text(
                (post.content).length > 160 && isPreview
                    ? '${post.content.substring(0, 160)}...'
                    : post.content,
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              relativeTimeNote(post.datetime)
            ],
          ),
        ),
      ),
    );
  }
}

Widget relativeTimeNote(String? datetime) {
  final postDate = DateTime.tryParse(datetime ?? '');
  final relativeTime = postDate != null
      ? timeago.format(postDate, locale: 'es')
      : 'No se sabe de cuando';

  return Row(
    children: [
      const Spacer(),
      Text(
        relativeTime,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
    ],
  );
}
