import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_theme.dart';
import 'package:flutter_application_1/models/post.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:flutter_application_1/services/handle_respones.dart';
import 'package:flutter_application_1/services/load_routes.dart';
import 'package:flutter_application_1/services/parse_service.dart';
import 'package:flutter_application_1/services/user_data_service.dart';
import 'package:flutter_application_1/data/app_data.dart';
import 'package:flutter_application_1/services/req_service.dart';
import 'package:flutter_application_1/widgets/comment_card.dart';
import 'package:flutter_application_1/widgets/leading_button.dart';
import 'package:flutter_application_1/widgets/post_card.dart';
import 'package:flutter_application_1/widgets/scroll_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _countryCodeController = 'ES';
  bool editing = false;
  bool _isUserDataLoaded = false;
  late Future<List<dynamic>> _postsFuture;
  late Future<List<dynamic>> _commentsFuture;
  late Future<List<dynamic>> _savedFuture;
  late String beName;
  late String beEmail;
  late String beCountry;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _refreshProfile();

    // Siempre inicializa _postsFuture para evitar LateInitializationError
    _postsFuture = _loadPosts();
    _commentsFuture = _loadComments();
    _savedFuture = _loadSaved();
  }

  bool _shouldEdit() {
    return beName != _nameController.text ||
        beEmail != _emailController.text ||
        beCountry != _countryCodeController ||
        _passwordController.text.isNotEmpty;
  }

  _saveBeforeEdit() {
    beName = _nameController.text;
    beEmail = _emailController.text;
    beCountry = _countryCodeController;
  }

  Future<List<dynamic>> _loadSaved() async {
    final posts = await getUserSavedPosts(context);

    return posts;
  }

  Future<List<dynamic>> _loadPosts() async {
    final posts = await getUserPosts(context);

    return posts;
  }

  Future<List<dynamic>> _loadComments() async {
    final posts = await getUserComments(context);

    return posts;
  }

  Future<void> _refreshProfile() async {
    setState(() {
      getUserData().then((userData) {
        _nameController.text = userData['nombre'] ?? '';
        _userName = _nameController.text;
        _emailController.text = userData['email'] ?? '';
        _countryCodeController = userData['countryCode'] ?? 'ES';
        _passwordController.clear();
        _saveBeforeEdit();
        setState(() {
          _isUserDataLoaded = true;
        });
      });
    });
  }

  Future<void> _editProfile() async {
    final String editProfileUrl = '${AppData.backendUrl}/users/editProfile';
    final String userToken = (await getToken())!;

    try {
      final response = await http.post(
        Uri.parse(editProfileUrl),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'username': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'nation': _countryCodeController
        }),
      );

      handleResponse(
        context: context,
        response: response,
        onSuccess: (responseData) async {
          // Guardar datos del usuario
          await saveUserData(responseData);
        },
        showMessage: true,
      );
    } catch (e) {
      // Manejar errores de conexión
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double fieldsWdth = 300;

    return Scaffold(
      appBar: AppBar(
        leading: LeadingButton(),
        title: const Text('Mi Perfil'),
      ),
      body: DefaultTabController(
        length: 3,
        child: !_isUserDataLoaded
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _refreshProfile,
                child: Stack(children: [
                  SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.92,
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      radius: 45,
                                      child: Icon(
                                        Icons.person,
                                        size: 65,
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                    // Nombre de usuario
                                    !editing
                                        ? Text(
                                            _nameController.text,
                                            style: GoogleFonts.ptSerif(
                                              fontSize: 27,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.lightBlack,
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.person_outline,
                                                  size: 30),
                                              const SizedBox(width: 16.0),
                                              SizedBox(
                                                width:
                                                    fieldsWdth, // O el ancho que tú quieras
                                                child: TextFormField(
                                                  controller: _nameController,
                                                  textAlign: TextAlign
                                                      .center, // Centra el texto dentro del campo
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall,
                                                  decoration:
                                                      const InputDecoration(
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 4),
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'El nombre no puede quedar vacío';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                    const SizedBox(height: 16.0),
                                    // Correo electrónico
                                    !editing
                                        ? Text(
                                            _emailController.text,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall,
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.email, size: 30),
                                              const SizedBox(width: 16.0),
                                              SizedBox(
                                                width: fieldsWdth,
                                                child: TextFormField(
                                                  controller: _emailController,
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall,
                                                  decoration:
                                                      const InputDecoration(
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 4),
                                                  ),
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'El correo no puede estar vacío';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                    // Campos contraseñas
                                    if (editing) ...[
                                      const SizedBox(height: 16.0),
                                      // Campo cambiar contraseña
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.lock_outline, size: 30),
                                          const SizedBox(width: 16.0),
                                          SizedBox(
                                            width: fieldsWdth,
                                            child: TextFormField(
                                              controller: _passwordController,
                                              obscureText: true,
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall,
                                              decoration: const InputDecoration(
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 4),
                                              ),
                                              validator: (value) {
                                                if (value != null &&
                                                    value.isNotEmpty &&
                                                    value.length < 6) {
                                                  return 'La contraseña debe tener al menos 6 caracteres';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16.0),
                                      // Campo repetir contraseña
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.lock_reset_outlined,
                                              size: 30),
                                          const SizedBox(width: 16.0),
                                          SizedBox(
                                            width: fieldsWdth,
                                            child: TextFormField(
                                              obscureText: true,
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall,
                                              decoration: const InputDecoration(
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 4),
                                              ),
                                              validator: (value) {
                                                if (value !=
                                                    _passwordController.text) {
                                                  return 'Las contraseñas no coinciden';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    const SizedBox(height: 16.0),
                                    CountryCodePicker(
                                      enabled: editing,
                                      onChanged: (code) {
                                        _countryCodeController = code.code!;
                                      },
                                      initialSelection: _countryCodeController,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 6),
                                      comparator: (a, b) =>
                                          b.name!.compareTo(a.name!),
                                      onInit: (code) {
                                        code!.name = code.code == 'ES'
                                            ? 'España'
                                            : code.name;
                                      },
                                      showCountryOnly: true,
                                      showOnlyCountryWhenClosed: true,
                                      textStyle: theme.textTheme.headlineSmall,
                                    ),
                                  ],
                                ),
                              ),
                              const TabBar(tabs: [
                                Tab(
                                  icon: Icon(Icons.article),
                                  text: 'Publicaciones',
                                ),
                                Tab(
                                  icon: Icon(Icons.comment),
                                  text: 'Comentarios',
                                ),
                                Tab(
                                  icon: Icon(Icons.bookmark),
                                  text: 'Guardados',
                                ),
                              ]),
                              Expanded(
                                  child: TabBarView(children: [
                                _buildPostList(),
                                _buildCommentList(),
                                _buildSavedList(),
                              ])),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  _buildButtonsRow(),
                ]),
              ),
      ),
    );
  }

  Widget _buildButtonsRow() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly, // o .center si prefieres
          children: [
            ElevatedButton(
              onPressed: () {
                if (editing) {
                  if (_formKey.currentState!.validate()) {
                    if (_shouldEdit()) {
                      _editProfile();
                    }
                    setState(() {
                      editing = false;
                    });
                    _refreshProfile();
                  }
                } else {
                  setState(() => editing = true);
                }
              },
              child: Text(editing ? 'Guardar' : 'Editar Perfil'),
            ),
            ElevatedButton(
              onPressed: () {
                logout(context);
              },
              child: const Text('Cerrar Sesión'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedList() {
    return FutureBuilder<List<dynamic>>(
      future: _savedFuture,
      builder: (c, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snap.hasError) {
          return Center(child: Text('Error: ${snap.error}'));
        } else if (snap.hasData) {
          final posts = snap.data!;

          return ScrollContainer(
            child: posts.isEmpty
                ? Center(
                    child: const Text(
                      'No has guardado ninguna publicación...',
                      textAlign: TextAlign.center,
                    ),
                  )
                : postsList(context, posts, username: _userName),
          );
        } else {
          return const Center(child: Text('No hay publicaciones'));
        }
      },
    );
  }

  Widget _buildCommentList() {
    return FutureBuilder<List<dynamic>>(
      future: _commentsFuture,
      builder: (c, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snap.hasError) {
          return Center(child: Text('Error: ${snap.error}'));
        } else if (snap.hasData) {
          final posts = snap.data!;

          return ScrollContainer(
            child: posts.isEmpty
                ? Center(
                    child: const Text(
                      'No has comentado nada...',
                      textAlign: TextAlign.center,
                    ),
                  )
                : postsList(context, posts, areComments: true),
          );
        } else {
          return const Center(child: Text('No hay publicaciones'));
        }
      },
    );
  }

  Widget _buildPostList() {
    return FutureBuilder<List<dynamic>>(
      future: _postsFuture,
      builder: (c, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snap.hasError) {
          return Center(child: Text('Error: ${snap.error}'));
        } else if (snap.hasData) {
          final posts = snap.data!;

          return ScrollContainer(
            child: posts.isEmpty
                ? Center(
                    child: const Text(
                      'No has publicado nada...',
                      textAlign: TextAlign.center,
                    ),
                  )
                : postsList(context, posts, username: _userName),
          );
        } else {
          return const Center(child: Text('No hay publicaciones'));
        }
      },
    );
  }
}

Widget postsList(BuildContext context, List<dynamic> posts,
    {bool areComments = false, String? username}) {
  return ListView.builder(
    itemCount: posts.length,
    itemBuilder: (c, i) {
      final postData = posts[i];
      final Post post = parsePost(postData, username: username);

      return !areComments
          ? PostCard(
              post: post,
              //isExpanded: false,
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.postScreen,
                arguments: {'post': post},
              ),
            )
          : CommentCard(
              comment: post,
              canBeAnswered: false,
              onPressedIcon: (post) {},
              onTap: () => loadPostScreen(context, post.parentPostId!),
            );
    },
  );
}
