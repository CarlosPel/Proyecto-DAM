import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_data.dart';
import 'package:flutter_application_1/data/user_data.dart';
import 'package:flutter_application_1/routes/routes.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Pantalla de inicio de sesión
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
      login(_emailController.text, _passwordController.text);
    }
  }

  Future<void> login(String email, String password) async {
    // URL del backend
    final String backendUrl = 'http://10.0.2.2:5000/users/login';

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
        goHomeScreen(response);
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

  void _goSingUp() {
    Navigator.pushNamed(context, AppRoutes.singUpScreen);
  }

  // Interfaz de el formulario de inicio de sesión
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
                /*Image.asset(
                  'assets/images/login.png',
                  color: Colors.blue,
                  fit: BoxFit.contain,
                  height: 150,
                ),*/

                SizedBox(height: 20),

                // Mensaje de bienvenida
                Text(
                  'Bienvenido a ${AppData.name}',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),

                SizedBox(height: 20),

                // Título de la pantalla
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

                // Texto para redirigir a la pantalla de registro
                TextButton(
                  onPressed: _goSingUp,
                  child: Text(
                    '¿No tienes una cuenta? Regístrate aquí',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Botón para saltarse el inicio de sesión
                ElevatedButton(
                  onPressed: () {
                    // Navigator.pushNamed(context, AppRoutes.homeScreen);
                    // lenin@prueba.com
                    login('lenin@prueba.com', '123456');
                  },
                  child: Text('Inicio rápido'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void goHomeScreen(http.Response response) {
    // Decodifica la respuesta JSON
    final responseData = jsonDecode(response.body);
    
    // Verifica que el estado esta asociado a un contexto montado
    if (mounted) {
      // Mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '${responseData['message']}. Bienvenido ${responseData['user']['username']}')),
      );

      // Guarda datos del usuario en shared preferences
      guardarDatosUsuario(responseData['user']['username'],
          responseData['user']['email'], responseData['user']['nation']);

      // Pasa a la pantalla principal
      print('5');
      Navigator.pushNamed(context, AppRoutes.homeScreen);
      print('6');
    }
  }
}
