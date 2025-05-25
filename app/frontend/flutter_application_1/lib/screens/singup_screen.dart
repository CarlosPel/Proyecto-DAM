import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_data.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_application_1/utilities/auth_service.dart';
import 'package:http/http.dart' as http;

// Pantalla de registro de cuenta
class SingUpScreen extends StatefulWidget {
  const SingUpScreen({super.key});

  @override
  SingUpScreenState createState() => SingUpScreenState();
}

class SingUpScreenState extends State<SingUpScreen> {
  // Controlador de texto para el correo electrónico
  final TextEditingController _emailController = TextEditingController();
  // Controlador de texto para la contraseña
  final TextEditingController _passwordController = TextEditingController();
  // Controlador de texto para el nombre de usuario
  final TextEditingController _usernameController = TextEditingController();
  // Controlador de texto para el país
  //final TextEditingController _countryController = TextEditingController();
  // Clave global para el formulario
  // Se utiliza para validar el formulario y acceder a su estado
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Variable para almacenar el país seleccionado
  String? country;

  // Método para manejar el registro de cuenta
  Future<void> _singUp() async {
    // Valida el formulario ejecutando los métodos de validación de cada campo
    if (_formKey.currentState!.validate()) {
      // Email y contraseña ingresados por el usuario
      final String email = _emailController.text;
      final String password = _passwordController.text;
      final String username = _usernameController.text;

      // URL del backend
      final String backendUrl = '${AppData.backendUrl}/users/register';

      try {
        // Guarda la respuesta (de tipo Response) de la solicitud HTTP POST
        final response = await http.post(
          Uri.parse(backendUrl),

          // Se especifica el tipo de contenido como JSON
          headers: {'Content-Type': 'application/json'},

          // Se envía el cuerpo de la solicitud codificado como JSON
          body: jsonEncode({
            'username': username,
            'email': email,
            'password': password,
            'nation': country,
          }),
        );

        // Verifica si la respuesta es exitosa (código 200)
        if (response.statusCode == 200) {
          if (mounted) {
            // Decodifica la respuesta JSON
            final responseData = jsonDecode(response.body);

            // Mensaje de éxito
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      '${responseData['message']}. Bienvenido ${responseData['user']['username']}')),
            );

            await loginUser(context: context, email: email, password: password);
          }
        } else {
          if (mounted) {
            // Mensaje de error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${response.body}')),
            );
          }
        }
      } catch (e) {
        // Manejar errores de conexión con el backend
        if (mounted) {
          // Mensaje de error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error de conexión: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person,
                        size: 72, color: theme.colorScheme.primary),
                    const SizedBox(height: 12),
                    Text(
                      'Únete a ${AppData.name}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Registro de cuenta',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 24),
                    // Nombre de usuario
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de usuario',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese un nombre de usuario';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese un correo electrónico';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Contraseña
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese una contraseña';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Confirmar contraseña
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Repetir contraseña',
                        prefixIcon: Icon(Icons.lock_reset_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Repita la contraseña';
                        } else if (value != _passwordController.text) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Selector de país
                    CountryCodePicker(
                      onChanged: (code) {
                        country = code.code;
                      },
                      initialSelection: 'ES',
                      onInit: (code) {
                        code!.name = 'España';
                        country = code.code;
                      },
                      showCountryOnly: true,
                      showOnlyCountryWhenClosed: true,
                    ),
                    const SizedBox(height: 24),
                    // Botón de registro
                    ElevatedButton.icon(
                      onPressed: _singUp,
                      icon: Icon(Icons.person_add_alt_1),
                      label: const Text('Registrarse'),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.loginScreen);
                      },
                      child: const Text(
                          '¿Ya tienes una cuenta? Inicia sesión aquí'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
