import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/article.dart';
import 'package:flutter_application_1/classes/post.dart';
import 'package:flutter_application_1/utilities/post_service.dart';
import 'package:flutter_application_1/utilities/req_service.dart';
import 'package:flutter_application_1/widgets/comment_widget.dart';

class PostScreen extends StatefulWidget {
  final Post? post;
  final Article? article;

  const PostScreen({super.key, this.post, this.article});

  @override
  State<PostScreen> createState() => PostScreenState();
}

class PostScreenState extends State<PostScreen> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _commentKeys = {};
  Map<String, dynamic>? _referencedComment;

  // Ir a commentario contestado
  /*void _scrollToIndex(int index) {
    final key = _commentKeys[index];
    if (key != null) {
      final context = key.currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero,
            ancestor: context.findRenderObject());
        _scrollController.animateTo(
          _scrollController.offset + position.dy,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }*/

  // Crea un comentario para una publicación
  Future<void> _commentPost(Post post) async {
    await createPost(
        context: context,
        post: Post(
          content: _commentController.text,
          parentPostId: _referencedComment != null
              ? _referencedComment!['id_post']
              : post.id,
        ));
    _refreshComments(post.id!);
  }

  // Recarga los comentarios de la publicación
  void _refreshComments(int postId) {
    setState(() {
      fetchComments(postId);
      _referencedComment = null;
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Post? post = widget.post;
    //final List<int> commentsIds = [];

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
                      controller: _scrollController,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        _commentKeys[comment['id_post']] = GlobalKey();
                        return Container(
                          key: _commentKeys[comment['id']],
                          child: CommentWidget(
                            comment: Post(
                              id: comment['id_post'],
                              content: comment['content'],
                              user: comment['user_name'],
                              parentPostId: comment['parent_post'],
                            ),
                            onPressedIcon: () {
                              setState(() {
                                _referencedComment = comment;
                              });
                              //_scrollToIndex(comment['parent_post']);
                            },
                          ),
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
            Column(
              children: [
                if (_referencedComment != null)
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${_referencedComment!['user_name']}: ${_referencedComment!['content']}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _referencedComment = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 64.0),
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
