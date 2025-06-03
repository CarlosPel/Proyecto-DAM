import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/handle_respones.dart';
import 'package:flutter_application_1/services/req_service.dart' as AppData;
import 'package:flutter_application_1/services/user_data_service.dart';
import 'package:http/http.dart' as http;

manageFollow(
    {required BuildContext context,
    required int userId,
    required dynamic Function(dynamic) onSuccess,
    bool follow = true}) async {
  final String getUserUrl =
      '${AppData.backendUrl}/user/${follow ? 'follow' : 'unfollow'}';
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
          body: jsonEncode({'user_id': userId}),
        ),
        onSuccess: onSuccess);
  } catch (e) {
    // Manejar errores de conexión
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error de conexión: $e')),
    );
  }
}
