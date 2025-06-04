import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/handle_respones.dart';
import 'package:flutter_application_1/services/req_service.dart' as AppData;
import 'package:flutter_application_1/services/user_data_service.dart';
import 'package:http/http.dart' as http;

Future<bool> checkIfFollowing(BuildContext context, int id) async {
  final String url = '${AppData.backendUrl}/users/followcheck';
  try {
    final String? token = await getToken();
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({'other_user_id': id}),
    );
    if (handleResponse(
        context: context, response: response, onSuccess: (response) {})) {
      return jsonDecode(response.body)['data'];
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

manageFollow(
    {required BuildContext context,
    required int userId,
    required dynamic Function(dynamic) onSuccess,
    bool follow = true}) async {
  final String getUserUrl =
      '${AppData.backendUrl}/users/${follow ? 'follow' : 'unfollow'}';
  try {
    final String? token = await getToken();

    handleResponse(
        context: context,
        response: await http.post(
          Uri.parse(getUserUrl),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
          body: jsonEncode({'other_user_id': userId}),
        ),
        onSuccess: onSuccess);
  } catch (e) {
    // Manejar errores de conexión
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error de conexión: $e')),
    );
  }
}
