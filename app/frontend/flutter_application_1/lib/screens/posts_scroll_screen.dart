import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/article.dart';
import 'package:flutter_application_1/models/post.dart';
import 'package:flutter_application_1/models/posts_notifier.dart';
import 'package:flutter_application_1/models/posts_state.dart';
import 'package:flutter_application_1/data/app_data.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:flutter_application_1/services/user_data_service.dart';
import 'package:flutter_application_1/screens/news_scroll_screen.dart';
import 'package:flutter_application_1/services/req_service.dart';
import 'package:flutter_application_1/widgets/newspaper_wrapper.dart';
import 'package:flutter_application_1/widgets/post_card.dart';
import 'package:flutter_application_1/widgets/scroll_container.dart';
import 'package:provider/provider.dart';

class PostsScrollScreen extends StatefulWidget {
  const PostsScrollScreen({super.key});

  @override
  PostsScrollScreenState createState() => PostsScrollScreenState();
}

class PostsScrollScreenState extends State<PostsScrollScreen> {
  late Future<List<dynamic>> _postsFuture;
  bool isOpen = false;

  @override
  void initState() {
    super.initState();

    // Escucha los cambios en PostsNotifier para recargar publicaciones si es necesario
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final postsNotifier = Provider.of<PostsNotifier>(context, listen: false);
      if (postsNotifier.shouldRefresh) {
        _refreshPosts();
        postsNotifier.reset();
      }
    });

    // Inicializa el Future para evitar errores de inicialización tardía
    _postsFuture = _loadPosts();
  }

  // Carga publicaciones desde la API según el país del usuario
  Future<List<dynamic>> _loadPosts() async {
    final userData = await getUserData();
    final countryCode = userData['countryCode'];
    final posts = await fetchPosts(context, countryCode);
    postsState.posts = posts;
    return posts;
  }

  // Refresca las publicaciones y muestra mensaje en caso de error
  Future<void> _refreshPosts() async {
    try {
      final newPosts = await _loadPosts();
      setState(() {
        postsState.posts = newPosts;
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
      appBar: AppBar(
        toolbarHeight: 100,
        title: SizedBox(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Título centrado
              Center(
                child: Text(
                  AppData.appName,
                  style: TextStyle(
                    fontFamily: 'Chomsky',
                    fontSize: 50,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Botón de perfil en la esquina superior derecha
              Positioned(
                right: 0,
                child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.profileScreen);
                  },
                  icon: Icon(Icons.person, size: 30),
                ),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            // Envoltura con apariencia de periódico
            NewspaperWrapper(
              screen: const NewsScrollScreen(),
              previusScreen: context,
              child: postsState.posts.isNotEmpty
                  ? RefreshIndicator(
                      onRefresh: _refreshPosts,
                      child: ScrollContainer(
                        child: _buildPostsList(postsState.posts),
                      ),
                    )
                  : FutureBuilder<List<dynamic>>(
                      future: _postsFuture,
                      builder: (c, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snap.hasError) {
                          return Center(child: Text('Error: ${snap.error}'));
                        } else if (snap.hasData) {
                          postsState.posts = snap.data!;
                          return RefreshIndicator(
                            onRefresh: _refreshPosts,
                            child: ScrollContainer(
                              child: postsState.posts.isEmpty
                                  ? SizedBox(
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                              'No hay publicaciones disponibles',
                                              textAlign: TextAlign.center),
                                          const SizedBox(height: 24),
                                          IconButton(
                                            onPressed: _refreshPosts,
                                            icon: const Icon(Icons.refresh),
                                          ),
                                        ],
                                      ),
                                    )
                                  : _buildPostsList(postsState.posts),
                            ),
                          );
                        } else {
                          return const Center(
                              child:
                                  Text('No hay publicaciones disponibles...'));
                        }
                      },
                    ),
            ),
            // Botón flotante para crear nueva publicación
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.createPostScreen);
                  },
                  icon: Icon(Icons.add, size: 40),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsList(List<dynamic> posts) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final postData = posts[index];
        final post = Post(
          id: postData['id_post'],
          title: postData['title'],
          content: postData['content'],
          datetime: postData['post_date'],
          user: postData['user_name'],
          article: Article(
            title: postData['noticia_title'],
            snippet: postData['noticia_content'],
            datetime: postData['noticia_fecha'], 
            source: postData['noticia_source'],
            link: postData['noticia_link'] ?? ,
          ),
        );
        return PostCard(
          post: post,
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.postScreen,
            arguments: {'post': post},
          ),
        );
      },
    );
  }
}
