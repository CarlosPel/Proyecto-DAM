import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/user_data.dart';
import 'package:flutter_application_1/utilities/news_service.dart';

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
      child: FutureBuilder<Map<String, String>>(
          future: getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error al cargar los datos'));
            } else if (snapshot.hasData) {
              final countryCode = snapshot.data!['countryCode'];
              return FutureBuilder<List<dynamic>>(
                  future: fetchTopHeadlines(countryCode),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(
                          child: Text('Error al cargar los datos'));
                    } else if (snapshot.hasData) {
                      final articles = snapshot.data!;
                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                articles[1]['title'] ?? 'Título de la noticia',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
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
                                child: Text(
                                    _isExpanded ? 'Mostrar menos' : 'Leer más'),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                          child: Text('No hay novedades en el frente'));
                    }
                  });
            } else {
              return const Center(child: Text('No hay novedades en el frente'));
            }
          }),
    );
  }
}

void main() => runApp(MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Noticia Expandible')),
        body: NewsWidget(),
      ),
    ));
