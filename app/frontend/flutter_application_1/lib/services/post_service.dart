import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/handle_respones.dart';
import 'package:flutter_application_1/services/req_service.dart' as AppData;
import 'package:flutter_application_1/services/user_data_service.dart';
import 'package:http/http.dart' as http;

Future<bool> checkIfSaved(BuildContext context, int id) async {
  final String url = '${AppData.backendUrl}/posts/checksaved';
  try {
    final String? token = await getToken();
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({'id_post': id}),
    );
    if (handleResponse(
        context: context,
        response: response,
        onSuccess: (response) {})) {
      return jsonDecode(response.body)['saved'];
    }
    return false;
  } catch (e) {
    // Manejar errores de conexión
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error de conexión: $e')),
    );
    return false;
  }
}

manageSavedPost(BuildContext context, int id, bool isSaved,
    {required Future<Null> Function(dynamic) onSuccess}) async {
  final String url =
      '${AppData.backendUrl}/posts/${isSaved ? 'unsave' : 'save'}';

  try {
    final String? token = await getToken();

    handleResponse(
        context: context,
        response: await http.post(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
          body: jsonEncode({'id_post': id}),
        ),
        onSuccess: onSuccess);
  } catch (e) {
    // Manejar errores de conexión
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error de conexión: $e')),
    );
  }
}
