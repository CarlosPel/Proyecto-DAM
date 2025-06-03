// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_data.dart';
import 'package:flutter_application_1/services/handle_respones.dart';
import 'package:flutter_application_1/services/user_data_service.dart';
import 'package:flutter_application_1/services/load_routes.dart';
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

// Inicia la sesión de un usuario
Future<bool> loginUser({
  // Contexto de la pantalla que llama a la función
  // Necesario para mostrar mensajes de éxito o error
  required BuildContext context,
  // Email de la cuenta
  required String email,
  // Contraseña de la cuenta
  required String password,
}) async {
  // Ruta de la raiz del backend
  final String loginUrl = '${AppData.backendUrl}/users/login';
  
  try {
    // Solicitud http para enviar al backend
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    // Devuelve verdadero si el código devuelto por el backend es 
    // de éxito o falso y un mensaje de error de lo contrario
    return handleResponse(
      context: context,
      // Respuesta de la solicitud del http.post
      response: response,
      // Acción que realiza ante respuesta de exito
      onSuccess: (responseData) async {
        // Guardar datos del usuario que devuelve el backend en el 
        // almacenamiento interno del dispositivo
        await saveUserData(responseData);
        // Mensaje de éxito, saliente desde el borde inferior
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Bienvenido, ${responseData['user']['username']}')),
        );
      },
    );
  } catch (e) {
    // En caso de error de conexión con el backend
    // Mensaje de error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error de conexión: $e')),
    );
    // Devuelve falso
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
