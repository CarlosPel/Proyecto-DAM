import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_data.dart';
import 'package:flutter_application_1/routes/routes.dart';
import 'package:flutter_application_1/utilities/auth_service.dart';

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
                  onPressed: () {
                    // Valida el formulario
                    if (_formKey.currentState!.validate()) {
                      // Si el formulario es válido, llama al método de inicio de sesión
                      loginUser(
                          context: context,
                          email: _emailController.text,
                          password: _passwordController.text);
                    }
                  },
                  child: Text('Iniciar sesión'),
                ),

                SizedBox(height: 20),

                // Texto para redirigir a la pantalla de registro
                TextButton(
                  onPressed: () {
                    // Navega a la pantalla de registro
                    Navigator.pushNamed(context, AppRoutes.singUpScreen);
                  },
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
                    loginUser(
                        context: context,
                        email: 'lenin@prueba.com',
                        password: '123456');
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
}
