import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/article.dart';
import 'package:flutter_application_1/classes/post.dart';
import 'package:flutter_application_1/utilities/post_service.dart';
import 'package:flutter_application_1/utilities/req_service.dart';

class PostScreen extends StatefulWidget {
  final Post? post;
  final Article? article;

  const PostScreen({super.key, this.post, this.article});

  @override
  State<PostScreen> createState() => PostScreenState();
}

class PostScreenState extends State<PostScreen> {
  final TextEditingController _commentController = TextEditingController();

  // Crea un comentario para una publicación
  Future<void> _commentPost(Post post) async {
    createPost(
        context: context,
        post: Post(
          content: _commentController.text,
          parentPost: post,
        ));
        _refreshComments(post.id!);
  }
  
  // Recarga los comentarios de la publicación
  void _refreshComments(int postId) {
    setState(() {
      fetchComments(postId);
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Post? post = widget.post;

    if (post != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(post.title!),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(post.content),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: fetchComments(post.id!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final comments = snapshot.data!;
                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return ListTile(
                          title: Text(comment['user_name']),
                          subtitle: Text(comment['content']),
                        );
                      },
                    );
                  } else {
                    return const Center(
                        child: Text('No hay comentarios disponibles'));
                  }
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 64.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Escribe un comentario...',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _commentPost(post),
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return const Scaffold(
        body: Center(child: Text('No hay publicación disponible')),
      );
    }
  }
}
