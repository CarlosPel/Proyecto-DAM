import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:flutter_application_1/models/post.dart';
import 'package:flutter_application_1/services/create_post_service.dart';
import 'package:flutter_application_1/services/load_routes.dart';
import 'package:flutter_application_1/services/post_service.dart';
import 'package:flutter_application_1/services/req_service.dart';
import 'package:flutter_application_1/services/user_data_service.dart';
import 'package:flutter_application_1/widgets/article_card.dart';
import 'package:flutter_application_1/widgets/article_container.dart';
import 'package:flutter_application_1/widgets/comment_card.dart';
import 'package:flutter_application_1/widgets/post_card.dart';

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
  late Future<bool> _isSaved;

  // Guarda las keys de los comentarios raíz
  final Map<int, GlobalKey<CommentCardState>> _commentKeys = {};

  late Future<bool> _isUsersPost;

  @override
  void initState() {
    super.initState();
    _loadComments();
    _isUsersPost = isUserPost();
    _checkIfSaved();
  }

  Future<bool> isUserPost() async {
    String? username = (await getUserData())['name'];
    return username == widget.post.author;
  }

  Future<void> _loadComments() async {
    final data = await getComments(context, widget.post.id!);
    setState(() {
      _comments = data;
      _saveCommentKeys();
    });
  }

  // Recarga los comentarios de la publicación
  Future<void> _refreshComments() async {
    final data = await getComments(context, widget.post.id!);
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

  _checkIfSaved() async {
    _isSaved = checkIfSaved(context, widget.post.id!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Post post = widget.post;

    return PopScope(
        canPop: false,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, size: 28),
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.postsScrollScreen,
                    (Route<dynamic> route) => false),
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.transparent),
                    foregroundColor: WidgetStateProperty.all(Colors.black))),
            title: Row(
              children: [
                Text(
                  post.author!,
                  style: theme.textTheme.headlineMedium,
                ),
                SizedBox(
                  width: 16,
                ),
                FutureBuilder(
                    future: _isUsersPost,
                    builder: (context, snap) {
                      if (snap.hasData) {
                        return Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            onPressed: () {
                              if (snap.data!) {
                                Navigator.pushNamed(
                                    context, AppRoutes.userProfileScreen);
                              } else {
                                loadProfile(context, post.author!, post);
                              }
                            },
                            icon: Icon(Icons.person, size: 25),
                          ),
                        );
                      } else {
                        return Icon(
                          Icons.person,
                          size: 20,
                        );
                      }
                    }),
                Spacer(),
                FutureBuilder(
                    future: _isSaved,
                    builder: (context, snap) {
                      IconData iconData = Icons.bookmark_outline;

                      if (snap.connectionState == ConnectionState.done &&
                          snap.hasData) {
                        iconData = snap.data!
                            ? Icons.bookmark
                            : Icons.bookmark_outline;
                      }
                      Icon icon = Icon(
                        iconData,
                        size: 40,
                      );
                      return IconButton(
                        onPressed: () async {
                          manageSavedPost(
                            context,
                            post.id!,
                            await _isSaved,
                            onSuccess: (response) async {
                              setState(() {
                                _checkIfSaved();
                              });
                            },
                          );
                        },
                        icon: icon,
                        color: Theme.of(context).colorScheme.primary,
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.transparent),
                        ),
                      );
                    })
              ],
            ),
          ),
          body: SafeArea(
            child: LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                reverse: true,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // Parte superior (article + post)
                        if (post.article != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ArticleContainer(
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
                          ),
                        PostCard(
                          post: post,
                          onTap: () {},
                          isPreview: false,
                        ),
                        Container(
                          color: const Color.fromARGB(214, 255, 241, 207),
                          width: double.infinity,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text(
                                'DEBATE',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ),
                        ),
                        // Listado de comentarios
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: _refreshComments,
                            child: _comments == null
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : Container(
                                    color: const Color.fromARGB(
                                        214, 255, 241, 207),
                                    padding: const EdgeInsets.all(8.0),
                                    child: _comments!.isEmpty
                                        ? SizedBox(
                                            width: double.infinity,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'No hay comentarios disponibles',
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 24),
                                                IconButton(
                                                  onPressed: _refreshComments,
                                                  icon:
                                                      const Icon(Icons.refresh),
                                                ),
                                              ],
                                            ),
                                          )
                                        : ListView.builder(
                                            itemCount: _comments!.length,
                                            itemBuilder: (context, index) {
                                              final comment = _comments![index];
                                              final key = _commentKeys[
                                                      comment['id_post']] ??
                                                  GlobalKey<CommentCardState>();
                                              _commentKeys[comment['id_post']] =
                                                  key;
                                              return CommentCard(
                                                key: key,
                                                comment: Post(
                                                  id: comment['id_post'],
                                                  content: comment['content'],
                                                  author: comment['user_name'],
                                                  parentPostId:
                                                      comment['parent_post'],
                                                  datetime:
                                                      comment['post_date'],
                                                ),
                                                onPressedIcon:
                                                    (Post selectedComment) {
                                                  setState(() {
                                                    _referencedComment = {
                                                      'id_post':
                                                          selectedComment.id,
                                                      'content': selectedComment
                                                          .content,
                                                      'user_name':
                                                          selectedComment
                                                              .author,
                                                    };
                                                  });
                                                },
                                              );
                                            },
                                          ),
                                  ),
                          ),
                        ),

                        // Campo de comentario + referencia
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
                              left: 16.0, right: 16.0, bottom: 12.0, top: 4),
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
                  ),
                ),
              );
            }),
          ),
        ));
  }
}
