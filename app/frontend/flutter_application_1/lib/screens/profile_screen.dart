import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/post.dart';
import 'package:flutter_application_1/classes/posts_notifier.dart';
import 'package:flutter_application_1/classes/user_posts_state.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:flutter_application_1/data/user_data.dart';
import 'package:flutter_application_1/utilities/auth_service.dart';
import 'package:flutter_application_1/data/app_data.dart';
import 'package:flutter_application_1/utilities/req_service.dart';
import 'package:flutter_application_1/widgets/post_widget.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _countryCodeController = 'ES';
  bool editing = false;
  bool _isUserDataLoaded = false;
  late Future<List<dynamic>> _postsFuture;
  late String beName;
  late String beEmail;
  late String beCountry;

  @override
  void initState() {
    super.initState();
    _refreshProfile();

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

  Future<List<dynamic>> _loadPosts() async {
    final posts = await fetchUserPosts(context);

    userPostsState.posts = posts;
    return posts;
  }

  Future<void> _refreshPosts() async {
    try {
      final newPosts = await _loadPosts();

      setState(() {
        userPostsState.posts = newPosts;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bienvenido de nuevo')),
      );
    }
  }

  Future<void> _refreshProfile() async {
    setState(() {
      getUserData().then((userData) {
        _nameController.text = userData['nombre'] ?? '';
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
        title: const Text('Mi Perfil'),
      ),
      body: !_isUserDataLoaded
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
                                  const CircleAvatar(
                                    radius: 50,
                                    child: Icon(Icons.person, size: 50),
                                  ),
                                  const SizedBox(height: 16.0),
                                  // Nombre de usuario
                                  !editing
                                      ? Text(
                                          _nameController.text,
                                          style: theme.textTheme.headlineSmall,
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
                                                keyboardType:
                                                    TextInputType.emailAddress,
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
                            Expanded(child: _buildPostList()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                _buildButtonsRow(),
              ]),
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

  Widget _buildPostList() {
    return userPostsState.posts.isNotEmpty
        ? ListView.builder(
            itemCount: userPostsState.posts.length,
            itemBuilder: (c, i) {
              final post = userPostsState.posts[i];
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
          )
        : FutureBuilder<List<dynamic>>(
            future: _postsFuture,
            builder: (c, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snap.hasError) {
                return Center(child: Text('Error: ${snap.error}'));
              } else if (snap.hasData) {
                userPostsState.posts = snap.data!;
                return ListView.builder(
                  itemCount: userPostsState.posts.length,
                  itemBuilder: (c, i) {
                    final post = userPostsState.posts[i];
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
                );
              } else {
                return const Center(child: Text('No hay publicaciones'));
              }
            },
          );
  }
}
