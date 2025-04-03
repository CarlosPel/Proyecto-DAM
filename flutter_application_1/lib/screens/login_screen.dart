import 'package:flutter/material.dart';

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
  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushNamed(context, '/home');
    }
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

                // Espacio entre los campos de texto
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
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Iniciar sesión'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
