import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/article.dart';
import 'package:flutter_application_1/classes/post.dart';
import 'package:flutter_application_1/utilities/post_service.dart';
import 'package:flutter_application_1/utilities/req_service.dart';
import 'package:flutter_application_1/widgets/comment_widget.dart';

class PostScreen extends StatefulWidget {
  final Post post;
  final Article? article;

  const PostScreen({super.key, required this.post, this.article});

  @override
  State<PostScreen> createState() => PostScreenState();
}

class PostScreenState extends State<PostScreen> {
  final TextEditingController _commentController = TextEditingController();
  //final Map<int, GlobalKey> _commentKeys = {};
  Map<String, dynamic>? _referencedComment;
  List<dynamic>? _comments;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    final data = await fetchComments(widget.post.id!);
    setState(() {
      _comments = data;
    });
  }

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
  Future<void> _refreshComments(int postId) async {
    final data = await fetchComments(postId);
    setState(() {
      _comments = data;
      _referencedComment = null;
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Post post = widget.post;

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
            child: _comments == null
                ? const Center(child: CircularProgressIndicator())
                : _comments!.isEmpty
                    ? const Center(
                        child: Text('No hay comentarios disponibles'))
                    : RefreshIndicator(
                      onRefresh: () => _refreshComments(post.id!),
                      child: ListView.builder(
                          itemCount: _comments!.length,
                          itemBuilder: (context, index) {
                            final comment = _comments![index];
                            return CommentWidget(
                              key: ValueKey(comment['id_post']),
                              comment: Post(
                                id: comment['id_post'],
                                content: comment['content'],
                                user: comment['user_name'],
                                parentPostId: comment['parent_post'],
                              ),
                              onPressedIcon: (Post selectedComment) {
                                setState(() {
                                  _referencedComment = {
                                    'id_post': selectedComment.id,
                                    'content': selectedComment.content,
                                    'user_name': selectedComment.user,
                                  };
                                });
                              },
                            );
                          },
                        ),
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
    }
}
