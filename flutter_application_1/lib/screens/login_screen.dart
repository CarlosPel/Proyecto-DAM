import 'package:flutter/material.dart';
import 'dart:convert'; // Para codificar los datos en JSON
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controlador de texto para el correo electrónico
  final TextEditingController _emailController = TextEditingController();

  // Controlador de texto para la contraseña
  final TextEditingController _passwordController = TextEditingController();

  // Clave global para el formulario
  // Se utiliza para validar el formulario y acceder a su estado
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Método para manejar el inicio de sesión
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text;
      final String password = _passwordController.text;

      try {
        final response = await http.post(
          Uri.parse('http://your-backend-url.com/api/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          // Manejar la respuesta exitosa, por ejemplo, guardar el token
          Navigator.pushNamed(context, '/home');
        } else {
          // Manejar errores, por ejemplo, credenciales incorrectas
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.body}')),
          );
        }
      } catch (e) {
        // Manejar errores de red u otros
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de conexión: $e')),
        );
      }
    }
  }

  void _register() {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Imagen

                Image.asset(
                  'assets/images/login.png',
                  color: Colors.blue,
                  fit: BoxFit.contain,
                  height: 150,
                ),

                SizedBox(height: 20),

                // Mensaje de bienvenida
                Text(
                  'Bienvenido a SPQR',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),

                SizedBox(height: 20),

                // Mensaje de bienvenida
                Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10),

                // Campo de texto para el correo electrónico
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Correo electrónico'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese su correo electrónico';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 10),

                // Campo de texto para la contraseña
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese su contraseña';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),

                // Botón de inicio de sesión
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Iniciar sesión'),
                ),

                SizedBox(height: 20),

                TextButton(
                  onPressed: _register,
                  child: Text(
                    '¿No tienes una cuenta? Regístrate aquí',
                    style: TextStyle(
                      color: Colors.blue, // Color del texto
                      decoration: TextDecoration
                          .underline, // Subrayado para indicar que es pulsable
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
