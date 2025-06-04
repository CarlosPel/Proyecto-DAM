import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/post.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:flutter_application_1/services/users_service.dart';
import 'package:flutter_application_1/widgets/post_card.dart';
import 'package:flutter_application_1/widgets/scroll_container.dart';

class ProfileScreen extends StatefulWidget {
  final Post userPost;
  final User user;

  const ProfileScreen(
    this.user,
    this.userPost, {
    super.key,
  });

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late Future<bool> _following;

  @override
  void initState() {
    super.initState();
    _checkIfFollowing();
  }

  _checkIfFollowing() async {
    _following = checkIfFollowing(context, widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    final User user = widget.user;
    final theme = Theme.of(context);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (a, e) {
        
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, size: 28),
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.postScreen, (Route<dynamic> route) => false,
                  arguments: {'post': widget.userPost}),
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.transparent),
                  foregroundColor: WidgetStateProperty.all(Colors.black))),
          title: const Text('Perfil'),
        ),
        body: DefaultTabController(
          length: 2,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 65),
                  ),
                  const SizedBox(height: 16.0),
                  // Nombre de usuario
                  Text(
                    user.name,
                    style: theme.textTheme.headlineLarge,
                  ),
                  // Campos contraseñas
                  const SizedBox(height: 8.0),
                  CountryCodePicker(
                    enabled: false,
                    initialSelection: user.country,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    comparator: (a, b) => b.name!.compareTo(a.name!),
                    onInit: (code) {
                      code!.name = code.code == 'ES' ? 'España' : code.name;
                    },
                    showCountryOnly: true,
                    showOnlyCountryWhenClosed: true,
                    textStyle: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16.0),
                  FutureBuilder(
                      future: _following,
                      builder: (context, snap) {
                        if (snap.hasData) {
                          bool following = snap.data!;
                          return ElevatedButton.icon(
                            onPressed: () {
                              manageFollow(
                                  context: context,
                                  userId: user.id,
                                  onSuccess: (response) async {
                                    setState(() {
                                      _checkIfFollowing();
                                    });
                                  },
                                  follow: !following);
                            },
                            label: Text(following ? 'Dejar de seguir' : 'Seguir'),
                            icon: Icon(following
                                ? Icons.person_remove
                                : Icons.person_add),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      }),
                  const SizedBox(height: 16.0),
                  const TabBar(tabs: [
                    Tab(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Icon(Icons.article),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Publicaciones'),
                        ])),
                    Tab(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Icon(Icons.comment),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Comentarios'),
                        ])),
                  ]),
                  Expanded(
                      child: TabBarView(children: [
                    _buildList(user.posts),
                    _buildList(user.comments),
                  ])),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList(List<dynamic> posts) {
    return posts.isNotEmpty
        ? ScrollContainer(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (c, i) {
                final postData = posts[i];
                final post = Post(
                  id: postData['id_post'],
                  title: postData['title'],
                  content: postData['content'],
                  datetime: postData['post_date'],
                  author: postData['user_name'],
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
            ),
          )
        : Center(
            child: Text('No tiene publicaciones'),
          );
  }
}
