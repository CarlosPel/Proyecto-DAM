// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/article.dart';
import 'package:flutter_application_1/models/post.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:flutter_application_1/enums/topic.dart';
import 'package:flutter_application_1/services/post_service.dart';
import 'package:flutter_application_1/widgets/fixed_article.dart';
import 'package:flutter_application_1/widgets/leading_button.dart';

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
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.postsScrollScreen,
            (Route<dynamic> route) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Article? article = widget.article;

    return Scaffold(
      appBar: AppBar(
        leading: LeadingButton(),
        title: Text('Nueva Publicación',
            style: TextStyle(
              fontSize: 25,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Título'),
                          controller: _titleController,
                          maxLength: 100,
                          minLines: 1,
                          maxLines: 2,
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
                          maxLength: 1000,
                          minLines: 3,
                          maxLines: 19,
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
                        Align(
                          alignment: Alignment.topCenter,
                          child: IntrinsicWidth(
                            child: ElevatedButton.icon(
                              onPressed: () => _createPost(article: article),
                              label: Text('Publicar'),
                              icon: Icon(Icons.send),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            if (article != null)
              FixedArticle(article),
          ]),
        ),
      ),
    );
  }
}
