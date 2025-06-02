import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_data.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:flutter_application_1/services/load_routes.dart';

// Pantalla de inicio de sesión con formulario y selección de usuarios de prueba
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  // Controladores para email y contraseña
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // Centra su hijo en el contenedor superior
      body: Center(
        // Hace a su hijo scrollable, en este caso para evitar problemas al
        //desplegarse el teclado
        child: SingleChildScrollView(
          // Espacio entre el hijo y el borde
          padding: const EdgeInsets.symmetric(horizontal: 24),
          // Widget con elevación
          child: Card(
            elevation: 8,
            // Redondea las esquinas
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              // Contenedor para elementos con validador para asegurar la
              // corrección de sus contenidos antes de realizar una acción
              child: Form(
                key: _formKey,
                // Contenedor vertical para varios hijos
                child: Column(
                  // Hace que la columna solo ocupe el espacio necesario para sus hijos.
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icono estilo templo griego
                    Image.asset(
                      'assets/images/logo_pnyx_no_back_color.png',
                      height: 100,
                    ),
                    // Espaciador
                    const SizedBox(height: 12),
                    // Frase de bienvenida en contenedor de texto fijo
                    Text(
                      'Bienvenid@ a ${AppData.appName}',
                      // Alinea el texto al centro del contendor
                      textAlign: TextAlign.center,
                      // Estilo del texto
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Título de la sección
                    Text(
                      'Inicio de sesión',
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    // Campo de email con validador
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
                    // Campo de texto para la contraseña
                    TextFormField(
                      // Variable en la que se almacena el contenido del campo
                      // cada vez que se modifica
                      controller: _passwordController,
                      // Oculta el texto para contraseñas
                      obscureText: true,
                      // Texto e iconos de decoración
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      // Contiene una condición para devolver el mensaje de error
                      // Si devuelve null se considera válido
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese su contraseña';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    // Botón de inicio de sesión
                    ElevatedButton.icon(
                      // Acción cuando se pulsa
                      onPressed: () {
                        // Comprueba que los campos cumplan los validadores
                        if (_formKey.currentState!.validate()) {
                          // Navega a la pantalla de carga para iniciar sesión
                          loadLogin(
                            context: context,
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                        }
                      },
                      // Icono
                      icon: Icon(Icons.login),
                      // Texto
                      label: Text('Entrar'),
                    ),
                    const SizedBox(height: 16),
                    // Enlace a pantalla de registro
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.singUpScreen),
                      child: Text('¿No tienes cuenta? Regístrate aquí'),
                    ),
                    // Dropdown para acceso rápido de usuarios de prueba
                    // DropdownButton<String>(
                    //   value: [
                    //     'paco@prueba.com',
                    //     'lenin@prueba.com',
                    //     'hamilton@prueba.com'
                    //   ].contains(_emailController.text)
                    //       ? _emailController.text
                    //       : null,
                    //   hint: Text('Usuarios de prueba'),
                    //   items: [
                    //     DropdownMenuItem(
                    //       value: 'paco@prueba.com',
                    //       child: Text('Paco'),
                    //     ),
                    //     DropdownMenuItem(
                    //       value: 'lenin@prueba.com',
                    //       child: Text('Lenin'),
                    //     ),
                    //     DropdownMenuItem(
                    //       value: 'hamilton@prueba.com',
                    //       child: Text('Hamilton'),
                    //     ),
                    //   ],
                    //   onChanged: (value) {
                    //     setState(() {
                    //       _emailController.text = value ?? '';
                    //       _passwordController.text = '123456';
                    //     });
                    //   },
                    // ),
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
