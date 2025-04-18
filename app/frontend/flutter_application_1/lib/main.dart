import 'package:flutter/material.dart';
import 'package:flutter_application_1/routes/routes.dart';

// Método de ejecución de la aplicación
void main() {
  runApp(MyApp());
}

// Clase principal de la aplicación
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
      initialRoute: AppRoutes.loginScreen,

      // Rutas de las pantallas
      routes: AppRoutes.getRoutes(),
    );
  }
}
