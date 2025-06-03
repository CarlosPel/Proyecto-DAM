import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/post.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:flutter_application_1/services/users_service.dart';
import 'package:flutter_application_1/widgets/leading_button.dart';
import 'package:flutter_application_1/widgets/post_card.dart';
import 'package:flutter_application_1/widgets/scroll_container.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen(this.user, {super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late bool _following;

  @override
  void initState() {
    super.initState();
    checkIfFollowing();
  }

  checkIfFollowing() {}

  @override
  Widget build(BuildContext context) {
    final User user = widget.user;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: LeadingButton(),
        title: const Text('Perfil'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Card(
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                const SizedBox(height: 16.0),
                // Campos contraseñas
                const SizedBox(height: 16.0),
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
                ElevatedButton.icon(
                  onPressed: () {
                    manageFollow(
                        context: context,
                        userId: user.id,
                        onSuccess: (response) {
                          setState(() {
                            _following = !_following;
                          });
                        },
                        follow: !_following);
                  },
                  label: Text(_following ? 'Dejar de seguir' : 'Seguir'),
                  icon:
                      Icon(_following ? Icons.person_remove : Icons.person_add),
                ),
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
    );
  }

  Widget _buildList(List<Post> posts) {
    return posts.isNotEmpty
        ? ScrollContainer(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (c, i) {
                final post = posts[i];

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
