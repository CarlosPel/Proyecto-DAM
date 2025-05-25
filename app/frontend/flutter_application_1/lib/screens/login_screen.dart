import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_data.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:flutter_application_1/utilities/load_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icono estilo templo griego
                    Icon(Icons.account_balance,
                        size: 72, color: Colors.indigo.shade700),
                    const SizedBox(height: 12),
                    // Frase de bienvenida con tono griego-democrático
                    Text(
                      'Bienvenidoa a ${AppData.appName}',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Inicio de sesión',
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Correo electrónico',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese su correo electrónico';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese su contraseña';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    // Botón de inicio ajustado a contenido
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            loadLogin(context: context, email: _emailController.text,
                                password: _passwordController.text);
                          }
                        },
                        icon: Icon(
                          Icons.login,
                        ),
                        label: Text('Entrar'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Registro
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.singUpScreen),
                      child: Text('¿No tienes cuenta? Regístrate aquí'),
                    ),
                    // Botón rápido (para pruebas)
                    /*Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            loginUser(
                              context: context,
                              email: 'paco@prueba.com',
                              password: '123456',
                            );
                          },
                          child: Text('Inicio rápido'),
                        ),*/
                    DropdownButton<String>(
                      value: ['paco@prueba.com', 'lenin@prueba.com', 'hamilton@prueba.com']
                              .contains(_emailController.text)
                          ? _emailController.text
                          : null,
                      hint: Text('Usuarios de prueba'),
                      items: [
                        DropdownMenuItem(
                          value: 'paco@prueba.com',
                          child: Text('Paco'),
                        ),
                        DropdownMenuItem(
                          value: 'lenin@prueba.com',
                          child: Text('Lenin'),
                        ),
                        DropdownMenuItem(
                          value: 'hamilton@prueba.com',
                          child: Text('Hamilton'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _emailController.text = value ?? '';
                          _passwordController.text = '123456';
                        });
                      },
                    ),
                  ],
                ),
                //],
                //),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
