import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:flutter_application_1/models/posts_notifier.dart';
import 'package:flutter_application_1/data/app_theme.dart';
import 'package:flutter_application_1/services/user_data_service.dart';
import 'package:flutter_application_1/services/load_routes.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

// Método de ejecución de la aplicación
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES');
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

      // Usamos AuthGate como pantalla inicial
      home: const AuthGate(),

      // Rutas de las pantallas
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}

// Widget que decide a dónde navegar según el estado de login
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isLoggedIn(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // Pantalla de carga mientras se verifica el login
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data == true) {
          // Usuario autenticado, ir a la pantalla principal
          WidgetsBinding.instance.addPostFrameCallback((_) {
            goHomeIfAgreed(context);
          });
          return const SizedBox.shrink();
        } else {
          // Usuario no autenticado, mostrar login
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.loginScreen);
          });
          return const SizedBox.shrink();
        }
      },
    );
  }
}
