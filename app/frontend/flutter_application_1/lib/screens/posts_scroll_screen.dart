import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/post.dart';
import 'package:flutter_application_1/classes/posts_notifier.dart';
import 'package:flutter_application_1/classes/posts_state.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:flutter_application_1/data/user_data.dart';
import 'package:flutter_application_1/screens/news_scroll_screen.dart';
import 'package:flutter_application_1/utilities/req_service.dart';
import 'package:flutter_application_1/widgets/newspaper_wrapper.dart';
import 'package:flutter_application_1/widgets/post_widget.dart';
import 'package:provider/provider.dart';
import 'package:turn_page_transition/turn_page_transition.dart';

class PostsScrollScreen extends StatefulWidget {
  const PostsScrollScreen({super.key});

  @override
  PostsScrollScreenState createState() => PostsScrollScreenState();
}

class PostsScrollScreenState extends State<PostsScrollScreen> {
  late Future<List<dynamic>> _postsFuture;
  // int _expandedIndex = -1;
  bool isOpen = false;

  @override
  void initState() {
    super.initState();

    // Escucha los cambios en PostsNotifier
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final postsNotifier = Provider.of<PostsNotifier>(context, listen: false);
      if (postsNotifier.shouldRefresh) {
        _refreshPosts();
        postsNotifier.reset();
      }
    });

    // Siempre inicializa _postsFuture para evitar LateInitializationError
    _postsFuture = _loadPosts();
  }

  // void _toggleExpanded(int index) {
  //   setState(() {
  //     _expandedIndex = (_expandedIndex == index) ? -1 : index;
  //   });
  // }

  Future<List<dynamic>> _loadPosts() async {
    final userData = await getUserData();
    final countryCode = userData['countryCode'];
    final posts = await fetchPosts(context, countryCode);
    postsState.news = posts;
    return posts;
  }

  Future<void> _refreshPosts() async {
    try {
      final newPosts = await _loadPosts();
      setState(() {
        postsState.news = newPosts;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bienvenido de nuevo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("What's New")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: NewspaperWrapper(
          onFoldTap: () {
            Navigator.of(context).push(
                // Use TurnPageRoute instead of MaterialPageRoute.
                TurnPageRoute(
              overleafColor: Colors.grey,
              animationTransitionPoint:
                  0.5, 
              transitionDuration: const Duration(milliseconds: 1000),
              reverseTransitionDuration: const Duration(milliseconds: 1000),
              builder: (context) => const NewsScrollScreen(),
            ));
            // Navigator.pushNamed(
            //   context,
            //   AppRoutes.newsScrollScreen,
            // );
          },
          child: postsState.news.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: _refreshPosts,
                  child: ListView.builder(
                    itemCount: postsState.news.length,
                    itemBuilder: (c, i) {
                      final post = postsState.news[i];
                      return PostWidget(
                        post: Post(
                          id: post['id_post'],
                          title: post['title'],
                          content: post['content'],
                          datetime: post['post_date'],
                          user: post['user_name'],
                        ),
                        //isExpanded: false,
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.postScreen,
                          arguments: {'post': post},
                        ),
                      );
                    },
                  ),
                )
              : FutureBuilder<List<dynamic>>(
                  future: _postsFuture,
                  builder: (c, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snap.hasError) {
                      return Center(child: Text('Error: ${snap.error}'));
                    } else if (snap.hasData) {
                      postsState.news = snap.data!;
                      return RefreshIndicator(
                        onRefresh: _refreshPosts,
                        child: ListView.builder(
                          itemCount: postsState.news.length,
                          itemBuilder: (c, i) {
                            final post = postsState.news[i];
                            return PostWidget(
                              post: Post(
                                id: post['id_post'],
                                title: post['title'],
                                content: post['content'],
                                datetime: post['post_date'],
                                user: post['user_name'],
                              ),
                              //isExpanded: false,
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRoutes.postScreen,
                                arguments: {'post': post},
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return const Center(child: Text('No hay publicaciones'));
                    }
                  },
                ),
        ),
      ),
    );
  }
}
// Botón Perfil
          /*AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            bottom: isOpen ? 100 : 40,
            right: isOpen ? 40 : 30,
            child: Visibility(
              visible: isOpen,
              child: FloatingActionButton(
                mini: true,
                onPressed: () {
                  if (Navigator.canPop(context) || AppRoutes.profileScreen != null) {
                    Navigator.pushNamed(context, AppRoutes.profileScreen);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ruta no encontrada: profileScreen')),
                    );
                  }
                },
                child: Icon(Icons.person),
              ),
            ),
          ),
          // Botón 2
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            bottom: isOpen ? 160 : 40,
            right: isOpen ? 100 : 30,
            child: Visibility(
              visible: isOpen,
              child: FloatingActionButton(
                mini: true,
                onPressed: () {
                  print('Botón 2');
                },
                child: Icon(Icons.photo),
              ),
            ),
          ),*/
      // Botón flotante de menú
      /*floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                isOpen = !isOpen;
              });
            },
            child: Icon(isOpen ? Icons.close : Icons.add),
          ),
        ),
      ),*/