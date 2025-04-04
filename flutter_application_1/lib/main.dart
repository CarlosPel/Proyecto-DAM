import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Quitar el banner (cintita roja esquina superior derecha) de depuración
      debugShowCheckedModeBanner: false,

      // Título de la aplicación
      title: 'SPQR',

      // Ruta de la pantalla inicial
      initialRoute: '/',

      // Rutas de las pantallas
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        // '/profile': (context) => ProfileScreen(),
      },
    );
  }
}