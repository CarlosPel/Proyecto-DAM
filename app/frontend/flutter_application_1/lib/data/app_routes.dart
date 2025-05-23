import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/create_post_screen.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/loading_screen.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/news_screen.dart';
import 'package:flutter_application_1/screens/post_screen.dart';
import 'package:flutter_application_1/screens/profile_screen.dart';
import 'package:flutter_application_1/screens/singup_screen.dart';
import 'package:flutter_application_1/screens/terms_screen.dart';

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
  // Ruta de la pantalla de noticias
  static const String newsScreen = '/news';
  // Ruta de la pantalla de creación de publicaciones
  static const String createPostScreen = '/createPost';
  // Ruta pantalla de publicación
  static const String postScreen = '/post';
  // Ruta pantalla de carga
  static const String loadingScreen = '/loading';
  // Ruta pantalla de términos y condiciones
  static const String termsScreen = '/terms';

  // Devuelve un mapa con las rutas de la aplicación
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final bool hasAgreed = args['hasAgreed'];
        return MaterialPageRoute(builder: (_) => HomeScreen(hasAgreed: hasAgreed,));
      case loginScreen:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case singUpScreen:
        return MaterialPageRoute(builder: (_) => SingUpScreen());
      case profileScreen:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case newsScreen:
        return MaterialPageRoute(builder: (_) => NewsScreen());
      case createPostScreen:
        return MaterialPageRoute(builder: (_) => CreatePostScreen());
      case postScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final post = args['post'];
        final article = args['article'];
        return MaterialPageRoute(
            builder: (_) => PostScreen(post: post, article: article));
      case loadingScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final String route = args['route'];
        final Future<bool> Function() loadCondition = args['loadCondition'];
        final Map<String, dynamic>? screenArgs = args['args'];
        return MaterialPageRoute(
            builder: (_) => LoadingScreen(
                route: route, loadCondition: loadCondition, args: screenArgs));
      case termsScreen:
        return MaterialPageRoute(builder: (_) => TermsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Ruta no encontrada: ${settings.name}')),
          ),
        );
    }
  }
}
