import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/profile_screen.dart';
import 'package:flutter_application_1/screens/singup_screen.dart';

// Almacena las rutas de la aplicación
class AppRoutes {
  // Ruta de la pantalla inicial
  static const String homeScreen = '/';
  // Ruta de la pantalla de inicio de sesión
  static const String loginScreen = '/login';
  // Ruta de la pantalla de registro
  static const String singUpScreen = '/singup';
  // Ruta de la pantalla de perfil
  static const String profileScreen = '/profile';

  // Devuelve un mapa con las rutas de la aplicación
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      homeScreen: (context) => HomeScreen(),
      loginScreen: (context) => LoginScreen(),
      singUpScreen: (context) => SingUpScreen(),
      profileScreen: (context) => ProfileScreen(),
    };
  }
}
