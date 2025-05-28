import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/user_data.dart';
import 'package:flutter_application_1/utilities/auth_service.dart';
import 'package:flutter_application_1/utilities/req_service.dart' as AppData;
import 'package:http/http.dart' as http;

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
  String? _countryCodeController;
  bool editing = false;
  bool _isUserDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _refreshProfile();
  }
  
  void _refreshProfile() {
    setState(() {
      getUserData().then((userData) {
      _nameController.text = userData['nombre'] ?? '';
      _emailController.text = userData['email'] ?? '';
      _countryCodeController = userData['countryCode'] ?? 'ES';
      _passwordController.clear();

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
          : Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(32.0),
              child: Form(
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.person_outline, size: 30),
                              const SizedBox(width: 16.0),
                              SizedBox(
                                width: fieldsWdth, // O el ancho que tú quieras
                                child: TextFormField(
                                  controller: _nameController,
                                  textAlign: TextAlign
                                      .center, // Centra el texto dentro del campo
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 4),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
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
                            style: Theme.of(context).textTheme.headlineSmall,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.email, size: 30),
                              const SizedBox(width: 16.0),
                              SizedBox(
                                width: fieldsWdth,
                                child: TextFormField(
                                  controller: _emailController,
                                  textAlign: TextAlign.center,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 4),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_outline, size: 30),
                          const SizedBox(width: 16.0),
                          SizedBox(
                            width: fieldsWdth,
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 4),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_reset_outlined, size: 30),
                          const SizedBox(width: 16.0),
                          SizedBox(
                            width: fieldsWdth,
                            child: TextFormField(
                              obscureText: true,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 4),
                              ),
                              validator: (value) {
                                if (value != _passwordController.text) {
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
                        _countryCodeController = code.code;
                      },
                      initialSelection: _countryCodeController ?? 'ES',
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
                    //Expanded(child: child),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        if (editing) {
                          if (_formKey.currentState!.validate()) {
                            _editProfile();
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
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        logout(context);
                      },
                      child: const Text('Cerrar Sesión'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
