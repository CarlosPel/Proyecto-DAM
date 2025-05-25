import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:flutter_application_1/utilities/auth_service.dart';

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
