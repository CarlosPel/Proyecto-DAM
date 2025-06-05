import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_theme.dart';
import 'package:flutter_application_1/models/post.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:flutter_application_1/screens/user_profile_screen.dart';
import 'package:flutter_application_1/services/users_service.dart';
import 'package:flutter_application_1/widgets/scroll_container.dart';
import 'package:google_fonts/google_fonts.dart';

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
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, size: 28),
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context,
                  AppRoutes.postsScrollScreen, (Route<dynamic> route) => false),
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
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    radius: 45,
                    child: Icon(
                      Icons.person,
                      size: 65,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Nombre de usuario
                  Text(
                    user.name,
                    style: GoogleFonts.ptSerif(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.lightBlack,
                    ),
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
                            label:
                                Text(following ? 'Dejar de seguir' : 'Seguir'),
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
                    _buildPostsList(),
                    _buildCommentList(),
                  ])),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//_commentsFuture
  Widget _buildCommentList() {
    final comments = widget.user.comments;

    return ScrollContainer(
      child: comments.isEmpty
          ? SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No has comentado nada...',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  const Icon(Icons.refresh),
                ],
              ),
            )
          : postsList(context, comments, areComments: true),
    );
  }

  Widget _buildPostsList() {
    final posts = widget.user.posts;

    return ScrollContainer(
      child: posts.isEmpty
          ? SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No has publicado nada...',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  const Icon(Icons.refresh),
                ],
              ),
            )
          : postsList(context, posts, username: widget.user.name),
    );
  }
}
