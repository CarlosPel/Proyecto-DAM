import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:flutter_application_1/models/post.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/services/req_service.dart';
import 'package:flutter_application_1/services/user_data_service.dart';
import 'package:flutter_application_1/services/auth_service.dart';

loadPostScreen(BuildContext context, int id) {
  Navigator.pushNamed(
    context,
    AppRoutes.loadingScreen,
    arguments: {
      'loadCondition': () async =>
          ((await getOlderPost(context, id)).id != null),
      'action': () async {
        Post post = await getOlderPost(context, id);
        Navigator.pushNamed(context, AppRoutes.postScreen,
            arguments: {'post': post,});
      },
    },
  );
}

loadProfile(BuildContext context, String name, Post userPost) {
  Navigator.pushNamed(
    context,
    AppRoutes.loadingScreen,
    arguments: {
      'loadCondition': () async =>
          ((await getUserByName(context, name)).id != 0),
      'action': () async {
        User user = await getUserByName(context, name);
        Navigator.pushNamed(context, AppRoutes.profileScreen,
            arguments: {'user': user, 'userPost': userPost});
      },
    },
  );
}

loadLogin(
    {required BuildContext context,
    required String email,
    required String password}) {
  Navigator.pushNamed(
    context,
    AppRoutes.loadingScreen,
    arguments: {
      'loadCondition': () async => true,
      'action': () async {
        if ((await loginUser(
          context: context,
          email: email,
          password: password,
        ))) {
          goHomeIfAgreed(context);
        } else {
          Navigator.pushNamed(context, AppRoutes.loginScreen);
        }
      },
    },
  );
}

// Método para manejar el registro de cuenta
loadSingUp(
    {required BuildContext context,
    required String email,
    required String password,
    required String username,
    required String country}) {
  Navigator.pushNamed(
    context,
    AppRoutes.loadingScreen,
    arguments: {
      'loadCondition': () async => true,
      'action': () async {
        if ((await singUpUser(
          context: context,
          email: email,
          password: password,
          username: username,
          country: country,
        ))) {
          loadLogin(context: context, email: email, password: password);
        } else {
          Navigator.pushNamed(context, AppRoutes.singUpScreen);
        }
      },
    },
  );
}

// Verifica si el usuario ha aceptado los términos y condiciones
goHomeIfAgreed(BuildContext context) {
  // Si el usuario ya está logueado, redirigir a la pantalla de inicio
  Navigator.pushNamed(context, AppRoutes.loadingScreen, arguments: {
    'loadCondition': () => isDataSaved(hasAgreed()),
    'action': () async {
      if ((await hasAgreed())!) {
        Navigator.pushNamed(context, AppRoutes.loadingScreen, arguments: {
          'loadCondition': () => isDataSaved(getToken()),
          'action': () async {
            Navigator.pushNamedAndRemoveUntil(context,
                AppRoutes.postsScrollScreen, (Route<dynamic> route) => false);
          }
        });
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.termsScreen, (Route<dynamic> route) => false);
      }
    }
  });
}
