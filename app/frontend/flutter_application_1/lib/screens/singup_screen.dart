import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_data.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_application_1/services/load_routes.dart';

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
  // Clave global para el formulario
  // Se utiliza para validar el formulario y acceder a su estado
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Variable para almacenar el país seleccionado
  late String? country;

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
                        size: 100, color: theme.colorScheme.primary),
                    const SizedBox(height: 12),
                    Text(
                      'Únete a ${AppData.appName}',
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
                        } else if (value.length < 6) {
                          return 'La contraseña debe tener al menos 6 caracteres';
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
                      textStyle: TextStyle(fontSize: 18,
                      color: Colors.black87,
                      fontStyle: FontStyle.normal),
                    ),
                    const SizedBox(height: 24),
                    // Botón de registro
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          loadSingUp(
                            context: context,
                            email: _emailController.text,
                            password: _passwordController.text,
                            country: country!,
                            username: _usernameController.text,
                          );
                        }
                      },
                      icon: Icon(Icons.assignment),
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
