import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/post.dart';
import 'package:flutter_application_1/data/app_routes.dart';

// Contenedor para mostrar las publicaciones
class PostWidget extends StatefulWidget {
  final Post post;
  /*final String titulo;
  final String contenido;*/
  final bool isExpanded;
  final VoidCallback onTap;

  const PostWidget(
      {super.key,
      required this.post,
      required this.onTap,
      required this.isExpanded});

  @override
  PostWidgetState createState() => PostWidgetState();
}

class PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    final Post post = widget.post;

    return Card(
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.postScreen,
          arguments: {
            'post': post,
            'article': post.article,
          },
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      post.title!,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
