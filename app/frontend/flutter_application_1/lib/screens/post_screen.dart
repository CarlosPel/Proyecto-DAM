import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/article.dart';
import 'package:flutter_application_1/classes/post.dart';
import 'package:flutter_application_1/utilities/post_service.dart';

class PostScreen extends StatefulWidget {
  final Post? post;
  final Article? article;

  const PostScreen({super.key, this.post, this.article});

  @override
  State<PostScreen> createState() => PostScreenState();
}

class PostScreenState extends State<PostScreen> {
  final TextEditingController _commentController = TextEditingController();

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
            Row(
              children: [
                TextField(),
                ElevatedButton(
                    onPressed: () => createPost(
                          context: context,
                          content: _commentController.text,
                        ),
                    child: Icon(Icons.send))
              ],
            )
          ],
        ),
      );
    }
    return Scaffold();
  }
}
