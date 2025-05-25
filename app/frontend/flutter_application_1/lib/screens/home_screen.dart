import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/post.dart';
import 'package:flutter_application_1/classes/posts_notifier.dart';
import 'package:flutter_application_1/classes/posts_state.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:flutter_application_1/data/user_data.dart';
import 'package:flutter_application_1/utilities/req_service.dart';
import 'package:flutter_application_1/widgets/post_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> _postsFuture;
  int _expandedIndex = -1;
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

  void _toggleExpanded(int index) {
    setState(() {
      _expandedIndex = (_expandedIndex == index) ? -1 : index;
    });
  }

  Future<List<dynamic>> _loadPosts() async {
    final userData = await getUserData();
    final countryCode = userData['countryCode'];
    final posts = await fetchPosts(countryCode);
    postsState.news = posts;
    return posts;
  }

  Future<void> _refreshPosts() async {
    final newPosts = await _loadPosts();
    setState(() {
      postsState.news = newPosts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text('What\'s New'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.newsScreen);
                  },
                  child: Icon(Icons.newspaper),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.createPostScreen);
                  },
                  child: Icon(Icons.add_a_photo),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.profileScreen);
                  },
                  child: Icon(Icons.person),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    logout();
                    Navigator.pushNamed(context, AppRoutes.loginScreen);
                  },
                  child: Icon(Icons.logout),
                ),
              ),
            ],
          ),
          postsState.news.isNotEmpty
              ? Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshPosts,
                    child: ListView.builder(
                      itemCount: postsState.news.length,
                      itemBuilder: (context, index) {
                        final post = postsState.news[index];
                        return PostWidget(
                          post: Post(
                            id: post['id_post'],
                            title: post['title'],
                            content: post['content'],
                            datetime: post['post_date'],
                            user: post['user_name'],
                          ),
                          isExpanded: _expandedIndex == index,
                          onTap: () => _toggleExpanded(index),
                        );
                      },
                    ),
                  ),
                )
              : Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: _postsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        postsState.news = snapshot.data!;
                        return RefreshIndicator(
                          onRefresh: _refreshPosts,
                          child: ListView.builder(
                            itemCount: postsState.news.length,
                            itemBuilder: (context, index) {
                              final post = postsState.news[index];
                              return PostWidget(
                                post: Post(
                                  id: post['id_post'],
                                  title: post['title'],
                                  content: post['content'],
                                  datetime: post['post_date'],
                                  user: post['user_name'],
                                ),
                                isExpanded: _expandedIndex == index,
                                onTap: () => _toggleExpanded(index),
                              );
                            },
                          ),
                        );
                      } else {
                        return const Center(
                            child: Text('No hay publicaciones disponibles'));
                      }
                    },
                  ),
                )
        ],
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