import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/user_data_service.dart';
import 'package:http/http.dart' as http;

bool handleResponse(
    {required BuildContext context,
    required http.Response response,
    required Function(dynamic) onSuccess,
    bool showMessage = false,
    bool showErrMessage = true}) {
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
  } else if (response.statusCode == 403) {
    // Si la respuesta es 403, se asume que el token no es válido o ha expirado
    logout(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('Ha expirado la sesión, por favor inicie sesión de nuevo')),
    );
    return false;
  } else {
    // Si hay un error, se muestra un mensaje al usuario
    if (showErrMessage) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.body)),
      );
    }
    return false;
  }
}
