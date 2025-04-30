// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/article.dart';
import 'package:flutter_application_1/classes/posts_notifier.dart';
import 'package:flutter_application_1/data/routes.dart';
import 'package:flutter_application_1/data/user_data.dart';
import 'package:flutter_application_1/enums/topic.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

Future<void> createPost(
    {required BuildContext context,
    Article? article,
    String? title,
    required String content,
    Topic? topic}) async {
  // URL del backend
  final String backendUrl = 'http://10.0.2.2:5000/posts/create';
  final Map<String, String> userData = await getUserData();

  try {
    // Guarda la respuesta (de tipo Response) de la solicitud HTTP POST
    final response = await http.post(
      Uri.parse(backendUrl),

      // Se especifica el tipo de contenido como JSON
      headers: {
        'Authorization': 'Bearer ${userData['token']}',
        'Content-Type': 'application/json'
      },

      //title, content, nation, topic, parent_post, noticia
      // Se envía el cuerpo de la solicitud codificado como JSON
      body: jsonEncode({
        'title': title,
        'content': content,
        'nation': userData['countryCode'],
        'topic': topic?.name,
        'parent_post': '', //parentPost ?? '',
        'noticia_title': article?.title,
        'noticia_content': article?.snippet,
        'noticia_url': article?.url,
        'noticia_datetime': article?.datetime,
        'noticia_source': article?.source,
      }),
    );

    // Verifica si la respuesta es exitosa (código 200)
    if (response.statusCode == 201) {
      // Decodifica la respuesta JSON
      final responseData = jsonDecode(response.body);

      // Mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'])),
      );

      // Notifica que los posts deben refrescarse
      Provider.of<PostsNotifier>(context, listen: false).markForRefresh();

      Navigator.pushNamed(context, AppRoutes.homeScreen);
    } else {
      // Mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.body}')),
      );
    }
  } catch (e) {
    // Manejar errores de conexión con el backend
    // Mensaje de error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error de conexión: $e')),
    );
  }
}
