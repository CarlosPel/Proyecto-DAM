import 'package:flutter/material.dart';

class NewsWidget extends StatefulWidget {
  const NewsWidget({super.key});

  @override
  NewsWidgetState createState() => NewsWidgetState();
}

class NewsWidgetState extends State<NewsWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Titular de la Noticia',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Subtítulo de la noticia.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ),
            Divider(),
            if (_isExpanded)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Este es el contenido completo de la noticia. Aquí puedes añadir más detalles o información relacionada con la noticia.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Text(_isExpanded ? 'Mostrar menos' : 'Leer más'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Noticia Expandible')),
        body: NewsWidget(),
      ),
    ));