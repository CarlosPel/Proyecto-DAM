import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/article.dart';

class CreatePostScreen extends StatefulWidget {
  final Article? article;

  const CreatePostScreen({super.key, this.article});

  @override
  CreatePostScreenState createState() => CreatePostScreenState();
}

class CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';

  void _submitPost() {
    if (_formKey.currentState!.validate()) {
      
    }
  }

  @override
  Widget build(BuildContext context) {
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
              if (widget.article != null) ...[
                Text(
                  widget.article!.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  widget.article!.snippet,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
              ],
              TextFormField(
                initialValue: _title, // Muestra el título inicial
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _content, // Muestra el contenido inicial
                decoration: InputDecoration(labelText: 'Contenido'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el contenido';
                  }
                  return null;
                },
                onSaved: (value) {
                  _content = value!;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitPost,
                child: Text('Publicar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}