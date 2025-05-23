// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_data.dart';
import 'package:flutter_application_1/data/user_data.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:http/http.dart' as http;

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
            Navigator.pushNamed(context, AppRoutes.homeScreen);
          }
        });
      } else {
        Navigator.pushNamed(context, AppRoutes.termsScreen);
      }
    }
  });
}

Future<void> agreeTerms(BuildContext context) async {
  final String agreeUrl = '${AppData.backendUrl}/users/conditions';

  try {
    final String? token = await getToken();

    final response = await http.post(
      Uri.parse(agreeUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      // Guardar datos del usuario
      await saveAgreement();

      // Navegar a la pantalla principal
      Navigator.pushNamed(context, AppRoutes.homeScreen);
    } else {
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.body}')),
      );
    }
  } catch (e) {
    // Manejar errores de conexión
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error de conexión: $e')),
    );
  }
}

Future<void> loginUser({
  required BuildContext context,
  required String email,
  required String password,
}) async {
  final String loginUrl = '${AppData.backendUrl}/users/login';

  try {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bienvenido ${responseData['user']['username']}'),
        ),
      );

      // Guardar datos del usuario
      await saveUserData(responseData);

      // Navegar a la pantalla principal
      goHomeIfAgreed(context);
    } else {
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.body}')),
      );
    }
  } catch (e) {
    // Manejar errores de conexión
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error de conexión: $e')),
    );
  }
}
