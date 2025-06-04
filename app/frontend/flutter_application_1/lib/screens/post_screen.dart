import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:flutter_application_1/models/post.dart';
import 'package:flutter_application_1/services/create_post_service.dart';
import 'package:flutter_application_1/services/load_routes.dart';
import 'package:flutter_application_1/services/req_service.dart';
import 'package:flutter_application_1/services/user_data_service.dart';
import 'package:flutter_application_1/widgets/article_card.dart';
import 'package:flutter_application_1/widgets/article_container.dart';
import 'package:flutter_application_1/widgets/comment_card.dart';
import 'package:flutter_application_1/widgets/leading_button.dart';
import 'package:flutter_application_1/widgets/post_card.dart';
import 'package:flutter_application_1/widgets/scroll_container.dart';

class PostScreen extends StatefulWidget {
  final Post post;

  const PostScreen({super.key, required this.post});

  @override
  State<PostScreen> createState() => PostScreenState();
}

class PostScreenState extends State<PostScreen> {
  final TextEditingController _commentController = TextEditingController();
  //final Map<int, GlobalKey> _commentKeys = {};
  Map<String, dynamic>? _referencedComment;
  List<dynamic>? _comments;
  bool _expandedIndex = false;

  // Guarda las keys de los comentarios raíz
  final Map<int, GlobalKey<CommentCardState>> _commentKeys = {};

  late Future<bool> _isUsersPost;

  @override
  void initState() {
    super.initState();
    _loadComments();
    _isUsersPost = isUserPost(); // <-- Asigna el Future aquí
  }

  Future<bool> isUserPost() async {
    String? username = (await getUserData())['name'];
    return username == widget.post.author;
  }

  Future<void> _loadComments() async {
    final data = await fetchComments(context, widget.post.id!);
    setState(() {
      _comments = data;
      _saveCommentKeys();
    });
  }

  // Recarga los comentarios de la publicación
  Future<void> _refreshComments() async {
    final data = await fetchComments(context, widget.post.id!);
    setState(() {
      _comments = data;
      _referencedComment = null;
      _commentController.clear();
      _saveCommentKeys();
    });

    for (var commentKey in _commentKeys.values) {
      if (commentKey.currentState != null) {
        commentKey.currentState!.refreshSubComments();
      }
    }
  }

  _saveCommentKeys() {
    _commentKeys.clear();
    if (_comments != null) {
      for (var comment in _comments!) {
        _commentKeys[comment['id_post']] = GlobalKey<CommentCardState>();
      }
    }
  }

  // Llama al método refreshSubComments de un CommentWidget específico por su id_post
  void refreshSubCommentsOf(int idPost) {
    final key = _commentKeys[idPost];
    setState(() {
      _referencedComment = null;
      _commentController.clear();
      if (key != null && key.currentState != null) {
        key.currentState!.refreshSubComments();
      }
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
    if (_referencedComment != null) {
      refreshSubCommentsOf(_referencedComment!['id_post']);
    } else {
      _refreshComments();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Post post = widget.post;

    return Scaffold(
      appBar: AppBar(
        leading: LeadingButton(),
        title: Row(
          children: [
            Text(post.author!),
            SizedBox(
              width: 8,
            ),
            FutureBuilder(
                future: _isUsersPost,
                builder: (context, snap) {
                  if (snap.hasData) {
                    return IconButton(
                      onPressed: () {
                        if (snap.data!) {
                          Navigator.pushNamed(
                              context, AppRoutes.userProfileScreen);
                        } else {
                          loadProfile(context, post.author!, post);
                        }
                      },
                      icon: Icon(Icons.person, size: 20),
                    );
                  } else {
                    return Icon(
                      Icons.person,
                      size: 20,
                    );
                  }
                }),
          ],
        ),
      ),
      body: Column(
        children: [
          if (post.article != null)
            ArticleContainer(
              ArticleCard(
                article: post.article!,
                isExpanded: _expandedIndex,
                onTap: () {
                  setState(() {
                    _expandedIndex = !_expandedIndex;
                  });
                },
              ),
            ),
          PostCard(
            post: post,
            onTap: () {},
            isPreview: false,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshComments,
              child: _comments == null
                  ? const Center(child: CircularProgressIndicator())
                  : ScrollContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _comments!.isEmpty
                            ? SizedBox(
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'No hay comentarios disponibles',
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 24),
                                    IconButton(
                                      onPressed: _refreshComments,
                                      icon: const Icon(Icons.refresh),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: _comments!.length,
                                itemBuilder: (context, index) {
                                  final comment = _comments![index];
                                  final key =
                                      _commentKeys[comment['id_post']] ??
                                          GlobalKey<CommentCardState>();
                                  _commentKeys[comment['id_post']] = key;
                                  return CommentCard(
                                    key: key,
                                    comment: Post(
                                      id: comment['id_post'],
                                      content: comment['content'],
                                      author: comment['user_name'],
                                      parentPostId: comment['parent_post'],
                                    ),
                                    onPressedIcon: (Post selectedComment) {
                                      setState(() {
                                        _referencedComment = {
                                          'id_post': selectedComment.id,
                                          'content': selectedComment.content,
                                          'user_name': selectedComment.author,
                                        };
                                      });
                                    },
                                  );
                                },
                              ),
                      ),
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
