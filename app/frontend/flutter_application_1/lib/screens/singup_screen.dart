import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_data.dart';
import 'package:flutter_application_1/routes/routes.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
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
      final String backendUrl = 'http://10.0.2.2:5000/users/register';

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
          // Decodifica la respuesta JSON
          // final responseData = jsonDecode(response.body);
          print('1');
          // Verifica que el estado esta asociado a un contexto montado
          if (mounted) {
            // Pasa a la pantalla principal
            print('2');
            LoginScreenState().goHomeScreen(response);
            print('3');
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
                  'Bienvenido a ${AppData.name}',
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

                // Campo de texto para el correo nombre de usuario
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Nombre de usuario'),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese un nombre de usuario';
                    }
                    return null;
                  },
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

                CountryCodePicker(
                  onChanged: (code) {
                    country = code.code;
                  },
                  initialSelection: 'ES',
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  comparator: (a, b) => b.name!.compareTo(a.name!),
                  onInit: (code) {
                    code!.name = 'España';
                    country = code.code;
                    /*debugPrint(
                        "on init ${code?.name} ${code?.dialCode} ${code?.name}");*/
                    /*print('insert into nation (code, nation_name) values\n');
                    for (var country in codes) {
                      print('(\'${country['code']}\', \'${country['name']}\'),');
                    }*/
                  },
                  showCountryOnly: true,
                  showOnlyCountryWhenClosed: true,
                ),
                /*Row(children: [

                  /*ElevatedButton(
                    onPressed: () {
                      showCountryPicker(
                        context: context,
                        onSelect: (Country country) {
                          setState(() {
                            selectedCountry = country.name;
                          });
                        },
                      );
                    },
                    child: Text('Selecciona un país'),
                  ),
                  TextFormField(
                    controller: _countryController,
                    decoration:
                        InputDecoration(labelText: 'Seleccione un país'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Selección un país';
                      }
                      return null;
                    },
                  ),*/
                ]),*/

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
