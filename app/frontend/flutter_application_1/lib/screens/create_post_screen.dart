// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_theme.dart';
import 'package:flutter_application_1/models/article.dart';
import 'package:flutter_application_1/models/post.dart';
import 'package:flutter_application_1/data/app_routes.dart';
import 'package:flutter_application_1/enums/topic.dart';
import 'package:flutter_application_1/services/create_post_service.dart';
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
  final List<Topic> _selectedTopics = [];
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
          topics: _selectedTopics,
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
      body: SingleChildScrollView(
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
                      SizedBox(
                        height: 200,
                        child: SingleChildScrollView(
                          child: Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: Topic.values.map((topic) {
                              final isSelected =
                                  _selectedTopics.contains(topic);
                              return FilterChip(
                                label: Text(topic.name),
                                selected: isSelected,
                                onSelected: (bool selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedTopics.add(topic);
                                    } else {
                                      _selectedTopics.remove(topic);
                                    }
                                  });
                                },
                                selectedColor: AppTheme.accentGold,
                                checkmarkColor: Colors.white,
                                shape: StadiumBorder(
                                  side: BorderSide(
                                    color: isSelected
                                        ? AppTheme.accentGold
                                        : Colors.grey,
                                    width: 1.2,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
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
            height: 8,
          ),
          if (article != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FixedArticle(article),
            ),
        ]),
      ),
    );
  }
}
