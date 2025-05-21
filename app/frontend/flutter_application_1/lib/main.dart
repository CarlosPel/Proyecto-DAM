import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:flutter_application_1/classes/posts_notifier.dart';
import 'package:flutter_application_1/data/app_theme.dart';
import 'package:provider/provider.dart';

// Método de ejecución de la aplicación
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PostsNotifier(),
      child: MyApp(),
    ),
  );
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
      title: 'Ágora',

      // Tema de la aplicación
      theme: AppTheme.lightTheme,

      // Ruta de la pantalla inicial
      initialRoute: AppRoutes.loginScreen,

      // Rutas de las pantallas
      routes: AppRoutes.getRoutes(),
    );
  }
}
