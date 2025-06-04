import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/article.dart';
import 'package:flutter_application_1/models/post.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/screens/create_post_screen.dart';
import 'package:flutter_application_1/screens/posts_scroll_screen.dart';
import 'package:flutter_application_1/screens/loading_screen.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/news_scroll_screen.dart';
import 'package:flutter_application_1/screens/post_screen.dart';
import 'package:flutter_application_1/screens/other_profile_screen.dart';
import 'package:flutter_application_1/screens/user_profile_screen.dart';
import 'package:flutter_application_1/screens/singup_screen.dart';
import 'package:flutter_application_1/screens/terms_screen.dart';

// Almacena las rutas de la aplicación
class AppRoutes {
  // Ruta de la pantalla inicial
  static const String postsScrollScreen = '/home';
  // Ruta de la pantalla de inicio de sesión
  static const String loginScreen = '/login';
  // Ruta de la pantalla de registro
  static const String singUpScreen = '/singup';
  // Ruta de la pantalla de perfil
  static const String userProfileScreen = '/userProfile';
  // Ruta de la pantalla de noticias
  static const String newsScrollScreen = '/news';
  // Ruta de la pantalla de creación de publicaciones
  static const String createPostScreen = '/createPost';
  // Ruta pantalla de publicación
  static const String postScreen = '/post';
  // Ruta pantalla de carga
  static const String loadingScreen = '/loading';
  // Ruta pantalla de términos y condiciones
  static const String termsScreen = '/terms';
  // Ruta pantalla de perfil de un usuario
  static const String profileScreen = '/profile';

  // Devuelve un mapa con las rutas de la aplicación
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case postsScrollScreen:
        return MaterialPageRoute(builder: (_) => PostsScrollScreen());

      case loginScreen:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case singUpScreen:
        return MaterialPageRoute(builder: (_) => SingUpScreen());

      case userProfileScreen:
        return MaterialPageRoute(builder: (_) => UserProfileScreen());

      case newsScrollScreen:
        return MaterialPageRoute(builder: (_) => NewsScrollScreen());

      case createPostScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        final Article? article = args?['article'];

        return MaterialPageRoute(
            builder: (_) => CreatePostScreen(article: article));

      case postScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final Post post = args['post'];

        return MaterialPageRoute(builder: (_) => PostScreen(post: post));

      case loadingScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final void Function() action = args['action'];
        final Future<bool> Function() loadCondition = args['loadCondition'];

        return MaterialPageRoute(
            builder: (_) =>
                LoadingScreen(action: action, loadCondition: loadCondition));

      case termsScreen:
        return MaterialPageRoute(builder: (_) => TermsScreen());

      case profileScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final User user = args['user'];
        final Post userPost = args['userPost'];

        return MaterialPageRoute(builder: (_) => ProfileScreen(user, userPost));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Ruta no encontrada: ${settings.name}')),
          ),
        );
    }
  }
}
