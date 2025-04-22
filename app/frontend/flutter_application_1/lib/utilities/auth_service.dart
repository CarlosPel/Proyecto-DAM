// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/user_data.dart';
import 'package:flutter_application_1/routes/routes.dart';
import 'package:http/http.dart' as http;

Future<void> loginUser({
  required BuildContext context,
  required String email,
  required String password,
}) async {
  final String loginUrl = 'http://10.0.2.2:5000/users/login';

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
          content: Text(
              '${responseData['message']}. Bienvenido ${responseData['user']['username']}'),
        ),
      );

      // Guardar datos del usuario
      await saveUserData(responseData);

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