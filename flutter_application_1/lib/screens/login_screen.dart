import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  // Controlador de texto para el correo electrónico
  final TextEditingController _emailController = TextEditingController();

  // Controlador de texto para la contraseña
  final TextEditingController _passwordController = TextEditingController();

  // Clave global para el formulario
  // Se utiliza para validar el formulario y acceder a su estado
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Método para manejar el inicio de sesión
  Future<void> _login() async {

    // Valida el formulario ejecutando los métodos de validación de cada campo
    if (_formKey.currentState!.validate()) {
      // Email y contraseña ingresados por el usuario
      final String email = _emailController.text;
      final String password = _passwordController.text;

      // URL del backend
      final String backendUrl = 'http://your-backend-url.com/api/login';

      try {
        // Guarda la respuesta (de tipo Response) de la solicitud HTTP POST
        final response = await http.post(
          Uri.parse(backendUrl),

          // Se especifica el tipo de contenido como JSON 
          headers: {'Content-Type': 'application/json'},

          // Se envía el cuerpo de la solicitud codificado como JSON
          body: jsonEncode({'email': email, 'password': password}),
        );

        // Verifica si la respuesta es exitosa (código 200)
        if (response.statusCode == 200) {
          // Decodifica la respuesta JSON
          // final responseData = jsonDecode(response.body);
          
          // Verifica que el estado esta asociado a un contexto montado
          if (mounted) {
            // Pasa a la pantalla principal
            Navigator.pushNamed(context, '/home');
          }
        } else {
          if (mounted) {
            // Muestra un mensaje de error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${response.body}')),
            );
          }
        }
      } catch (e) {
        // Manejar errores de red u otros
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error de conexión: $e')),
          );
        }
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
