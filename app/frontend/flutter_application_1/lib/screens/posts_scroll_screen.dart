import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_theme.dart';
import 'package:flutter_application_1/enums/topic.dart';
import 'package:flutter_application_1/models/posts_notifier.dart';
import 'package:flutter_application_1/models/posts_state.dart';
import 'package:flutter_application_1/data/app_data.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:flutter_application_1/services/parse_service.dart';
import 'package:flutter_application_1/services/user_data_service.dart';
import 'package:flutter_application_1/screens/news_scroll_screen.dart';
import 'package:flutter_application_1/services/req_service.dart';
import 'package:flutter_application_1/widgets/icon_dropdown_button.dart';
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
  late Future<List<dynamic>> Function() _postsSource;
  final List<Topic> _selectedTopics = [];

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
    _postsSource = _getLocalPosts;
    // Inicializa el Future para evitar errores de inicialización tardía
    _postsFuture = _loadPosts();
  }

  Future<List<dynamic>> _getTopicsPosts() async {
    return getTopicsPosts(context, _selectedTopics);
  }

  Future<List<dynamic>> _getLocalPosts() async {
    final userData = await getUserData();
    final countryCode = userData['countryCode'];

    return getPosts(context, country: countryCode);
  }

  Future<List<dynamic>> _getFollowingPosts() async {
    return getFollowingPosts(context);
  }

  Future<List<dynamic>> _getGlobalPosts() async {
    return getPosts(context);
  }

  // Carga publicaciones desde la API según el país del usuario
  Future<List<dynamic>> _loadPosts() async {
    final posts = await _postsSource();
    postsState.posts = posts;

    return posts;
  }

  // Refresca las publicaciones y muestra mensaje en caso de error
  Future<void> _refreshPosts() async {
    try {
      final newPosts = await _loadPosts();

      setState(() {
        postsState.posts = newPosts;
        _postsFuture = Future.value(newPosts);
      });

      _selectedTopics.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bienvenido de nuevo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color pnyxColor = Theme.of(context).colorScheme.primary;

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
                    fontSize: 50,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                    color: pnyxColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Botón de filtros
              FutureBuilder(
                  future: _postsSource(),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      return Positioned(
                        left: 0,
                        child: IconDropdownButton(
                          onSelected: (String selectedOption) {
                            setState(() {
                              switch (selectedOption) {
                                case IconDropdownButtonState.yourEnv:
                                  _postsSource = _getLocalPosts;
                                  break;
                                case IconDropdownButtonState.following:
                                  _postsSource = _getFollowingPosts;
                                  break;
                                case IconDropdownButtonState.explore:
                                  _postsSource = _getGlobalPosts;
                                  break;
                              }
                              _postsFuture = _loadPosts();
                            });
                            if (selectedOption ==
                                IconDropdownButtonState.seeTopics) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Elegir temas'),
                                    content: SizedBox(
                                      height: 200,
                                      child: StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setModalState) {
                                          return SingleChildScrollView(
                                            child: Wrap(
                                              spacing: 8.0,
                                              runSpacing: 4.0,
                                              children:
                                                  Topic.values.map((topic) {
                                                final isSelected =
                                                    _selectedTopics
                                                        .contains(topic);
                                                return FilterChip(
                                                  label: Text(topic.name),
                                                  selected: isSelected,
                                                  onSelected: (bool selected) {
                                                    setModalState(() {
                                                      setState(() {
                                                        if (selected) {
                                                          _selectedTopics
                                                              .add(topic);
                                                        } else {
                                                          _selectedTopics
                                                              .remove(topic);
                                                        }
                                                      });
                                                    });
                                                  },
                                                  selectedColor:
                                                      AppTheme.accentGold,
                                                  checkmarkColor: Colors.white,
                                                  shape: StadiumBorder(
                                                    side: BorderSide(
                                                      color: isSelected
                                                          ? AppTheme.accentGold
                                                          : Colors.grey,
                                                      width: 1.2,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text('Cancelar'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_selectedTopics.isNotEmpty) {
                                            setState(() {
                                              _postsSource = _getTopicsPosts;
                                              _refreshPosts();
                                            });
                                            Navigator.of(context).pop();
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Selecciona al menos un tema')),
                                            );
                                          }
                                        },
                                        child: Text('Aceptar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                            _refreshPosts();
                          },
                        ),
                      );
                    }
                    return Positioned(
                      left: 0,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.place, size: 30),
                      ),
                    );
                  }),
              // Botón de perfil en la esquina superior derecha
              Positioned(
                right: 0,
                child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.userProfileScreen);
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
        final post = parsePost(postData);

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
