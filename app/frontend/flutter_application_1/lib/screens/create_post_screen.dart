import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/article.dart';
import 'package:flutter_application_1/classes/posts_notifier.dart';
import 'package:flutter_application_1/data/routes.dart';
import 'package:flutter_application_1/data/user_data.dart';
import 'package:flutter_application_1/enums/topic.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  final Article? article;

  const CreatePostScreen({super.key, this.article});

  @override
  CreatePostScreenState createState() => CreatePostScreenState();
}

class CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  late Topic _topic;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  //late int? parentPost;

  Future<void> _createPost({Article? article}) async {
    final String title = _titleController.text;
    final String content = _contentController.text;

    // URL del backend
    final String backendUrl = 'http://10.0.2.2:5000/posts/create';
    final Map<String, String> userData = await getUserData();

    if (_formKey.currentState!.validate()) {
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
            'topic': _topic.name,
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
          if (mounted) {
            // Decodifica la respuesta JSON
            final responseData = jsonDecode(response.body);

            // Mensaje de éxito
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseData['message'])),
            );

            // Notifica que los posts deben refrescarse
            Provider.of<PostsNotifier>(context, listen: false).markForRefresh();

            Navigator.pushNamed(context, AppRoutes.homeScreen);
          }
        } else {
          if (mounted) {
            // Mensaje de error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${response.body}')),
            );
          }
        }
      } catch (e) {
        // Manejar errores de conexión con el backend
        if (mounted) {
          // Mensaje de error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error de conexión: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Article? article = widget.article;

    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Nuevo Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (article != null) ...[
                Text(
                  article.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                if (article.snippet != null) ...[
                  Text(
                    article.snippet!,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                ]
              ],
              TextFormField(
                decoration: InputDecoration(labelText: 'Título'),
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contenido'),
                controller: _contentController,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el contenido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<Topic>(
                decoration: InputDecoration(labelText: 'Tema'),
                items: Topic.values.map((Topic topic) {
                  return DropdownMenuItem<Topic>(
                    value: topic,
                    child: Text(topic.name),
                  );
                }).toList(),
                onChanged: (Topic? newValue) {
                  setState(() {
                    _topic = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor selecciona un tema';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _createPost(article: article),
                child: Text('Publicar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
