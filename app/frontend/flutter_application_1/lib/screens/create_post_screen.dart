// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/article.dart';
import 'package:flutter_application_1/classes/post.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:flutter_application_1/enums/topic.dart';
import 'package:flutter_application_1/utilities/post_service.dart';
import 'package:flutter_application_1/widgets/article_card.dart';
import 'package:flutter_application_1/widgets/article_preview.dart';

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

  Future<void> _createPost({Article? article}) async {
    final String title = _titleController.text;
    final String content = _contentController.text;

    if (_formKey.currentState!.validate()) {
      createPost(
        context: context,
        post: Post(
          title: title,
          content: content,
          topic: _topic,
          article: article,
        ),
      ).then((_) {
        // Navega a la pantalla de inicio después de crear el post
        Navigator.pushNamed(context, AppRoutes.postsScrollScreen);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Article? article = widget.article;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Nueva Publicación',
        style: TextStyle(
          fontSize: 25,
        )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
            if (article != null) ...[
              SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Artículo',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  )),
              articleCard(
                child: Column(children: [
                  ArticlePreview(
                    title: article.title,
                    source: article.source,
                    datetime: article.datetime,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      article.snippet!,
                      style: const TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                ]),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
