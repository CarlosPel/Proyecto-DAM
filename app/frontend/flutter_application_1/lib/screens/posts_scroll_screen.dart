import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/post.dart';
import 'package:flutter_application_1/classes/posts_notifier.dart';
import 'package:flutter_application_1/classes/posts_state.dart';
import 'package:flutter_application_1/data/app_data.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:flutter_application_1/data/user_data.dart';
import 'package:flutter_application_1/screens/news_scroll_screen.dart';
import 'package:flutter_application_1/utilities/req_service.dart';
import 'package:flutter_application_1/widgets/newspaper_wrapper.dart';
import 'package:flutter_application_1/widgets/post_card.dart';
import 'package:flutter_application_1/widgets/scroll_container.dart';
import 'package:provider/provider.dart';
import 'package:turn_page_transition/turn_page_transition.dart';
import 'package:google_fonts/google_fonts.dart';

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
    postsState.posts = posts;
    return posts;
  }

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
          height: 100,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                  child: Text(
                AppData.appName,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              )),
              Positioned(
                right: 0,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.profileScreen);
                  },
                  child: Icon(Icons.person, size: 30), // Icono del botón
                ),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Stack(children: [
          NewspaperWrapper(
            onFoldTap: () {
              Navigator.of(context).push(
                  // Use TurnPageRoute instead of MaterialPageRoute.
                  TurnPageRoute(
                overleafColor: Colors.grey,
                animationTransitionPoint: 0.5,
                transitionDuration:
                    const Duration(milliseconds: AppData.pageTurnTime),
                reverseTransitionDuration:
                    const Duration(milliseconds: AppData.pageTurnTime),
                builder: (context) => const NewsScrollScreen(),
              ));
              // Navigator.pushNamed(
              //   context,
              //   AppRoutes.newsScrollScreen,
              // );
            },
            child: postsState.posts.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: _refreshPosts,
                    child: ScrollContainer(
                      child: ListView.builder(
                        itemCount: postsState.posts.length,
                        itemBuilder: (c, i) {
                          final post = postsState.posts[i];
                          return PostCard(
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
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 24),
                                        ElevatedButton(
                                          onPressed: _refreshPosts,
                                          child: const Icon(Icons.refresh),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: postsState.posts.length,
                                    itemBuilder: (c, i) {
                                      final post = postsState.posts[i];
                                      return PostCard(
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
                          ),
                        );
                      } else {
                        return const Center(
                            child: Text('No hay publicaciones disponibles...'));
                      }
                    },
                  ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.createPostScreen);
                },
                child: Icon(Icons.add, size: 30), // Icono del botón
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
