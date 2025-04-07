import 'package:flutter/material.dart';
import 'package:flutter_application_1/routes/routes.dart';

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
  // Clave global para el formulario
  // Se utiliza para validar el formulario y acceder a su estado
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Método para manejar el registro de cuenta
  void _singUp() {
    // Valida el formulario ejecutando los métodos de validación de cada campo
    if (_formKey.currentState!.validate()) {
      
    }
  }

  void _goLogin() {
    Navigator.pushNamed(context, AppRoutes.loginScreen);
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
                  'assets/images/singup.png',
                  color: Colors.blue,
                  fit: BoxFit.contain,
                  height: 150,
                ),*/

                SizedBox(height: 20),

                // Mensaje de bienvenida
                Text(
                  'Bienvenido a SPQR',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),

                SizedBox(height: 20),

                // Título de la pantalla
                Text(
                  'Crear una cuenta',
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
                      return 'Ingrese un correo electrónico';
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
                      return 'Ingrese una contraseña';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 10),

                // Campo de texto para repetir la contraseña
                TextFormField(
                  decoration: InputDecoration(labelText: 'Repetir contraseña'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Repita la contraseña';
                    } else if (value != _passwordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),

                // Botón de registro de cuenta
                ElevatedButton(
                  onPressed: _singUp,
                  child: Text('Registrarse'),
                ),

                SizedBox(height: 20),

                TextButton(
                  onPressed: _goLogin,
                  child: Text(
                    '¿Ya tienes una cuenta? Inicia sesión aquí',
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
