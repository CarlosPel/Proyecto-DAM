// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_data.dart';
import 'package:flutter_application_1/data/user_data.dart';
import 'package:flutter_application_1/utilities/load_routes.dart';
import 'package:http/http.dart' as http;

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

    handleResponse(
      context: context,
      response: response,
      onSuccess: (responseData) async {
        // Guardar datos del usuario
        await saveAgreement();

        // Navegar a la pantalla principal
        goHomeIfAgreed(context);
      },
    );
  } catch (e) {
    // Manejar errores de conexión
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error de conexión: $e')),
    );
  }
}

bool handleResponse(
    {required BuildContext context,
    required http.Response response,
    required Function(dynamic) onSuccess,
    bool showMessage = false}) {
  if (response.statusCode == 200) {
    // Si la respuesta es exitosa, se puede procesar el cuerpo de la respuesta
    final responseData = jsonDecode(response.body);

    // Llamar a la función de éxito
    onSuccess(responseData);

    if (responseData['message'] != null && showMessage) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'])),
      );
    }

    return true;
  } else {
    // Si hay un error, se muestra un mensaje al usuario
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${response.body}')),
    );
    return false;
  }
}

Future<List<dynamic>> handleTokenSent(
    {required BuildContext context,
    required http.Response response,
    required Future<List<dynamic>> Function(dynamic) onSuccess,
    bool showMessage = false}) {
  if (response.statusCode == 200) {
    // Si la respuesta es exitosa, se puede procesar el cuerpo de la respuesta
    final responseData = jsonDecode(response.body);

    if (responseData['message'] != null && showMessage) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'])),
      );
    }

    // Llamar a la función de éxito
    return onSuccess(responseData);
  } else if (response.statusCode == 401) {
    // Si la respuesta es 401, se asume que el token no es válido o ha expirado
    logout(context);
    throw Exception(
      'Error: ${response.statusCode} - ${response.body}',
    );
  } else {
    // Si hay un error, se muestra un mensaje al usuario
    throw Exception(
      'Error: ${response.statusCode} - ${response.body}',
    );
  }
}

Future<bool> loginUser({
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

    return handleResponse(
      context: context,
      response: response,
      onSuccess: (responseData) async {
        // Guardar datos del usuario
        await saveUserData(responseData);
        // Mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Bienvenido, ${responseData['user']['username']}')),
        );
      },
    );
  } catch (e) {
    // Manejar errores de conexión
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error de conexión: $e')),
    );
    return false;
  }
}

Future<bool> singUpUser(
    {required BuildContext context,
    required String email,
    required String password,
    required String username,
    required String country}) async {
  // URL del backend
  final String backendUrl = '${AppData.backendUrl}/users/register';

  try {
    // Guarda la respuesta (de tipo Response) de la solicitud HTTP POST
    final response = await http.post(
      Uri.parse(backendUrl),

      // Se especifica el tipo de contenido como JSON
      headers: {'Content-Type': 'application/json'},

      // Se envía el cuerpo de la solicitud codificado como JSON
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'nation': country,
      }),
    );

    return handleResponse(
      context: context,
      response: response,
      onSuccess: (responseData) async {
        // Mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario registrado correctamente')),
        );
      },
    );
  } catch (e) {
    // Manejar errores de conexión con el backend
    // Mensaje de error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error de conexión: $e')),
    );

    return false;
  }
}
