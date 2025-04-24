import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/user_data.dart';
import 'package:flutter_application_1/utilities/news_service.dart';
import 'package:flutter_application_1/widgets/news_widget.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  NewsScreenState createState() => NewsScreenState();
}

class NewsScreenState extends State<NewsScreen> {
  // Future para cargar las noticias
  late Future<List<dynamic>> _newsFuture;

  // Carga las noticias al crearse el estado de la pantalla de noticias
  @override
  void initState() {
    super.initState();
    _newsFuture = _loadNews();
  }

  // Carga las noticias
  Future<List<dynamic>> _loadNews() async {
    // Se obtiene el código de país del usuario del almacenamiento local
    final userData = await getUserData();
    final countryCode = userData['countryCode'];

    // Se carga la lista de noticias usando el código de país
    return fetchTopHeadlines(countryCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noticias'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final articles = snapshot.data!;

            // Lista scrolleable de noticias
            return ListView.builder(
              // Número de elementos en la lista = número de artículos
              itemCount: articles.length,
              itemBuilder: (context, index) {
                // Artículo correspondiente al número de elemento de la lista
                final article = articles[index];
                return NewsWidget(
                    titulo: article['title'],
                    contenido: article['description']);
              },
            );
          } else {
            return const Center(child: Text('No hay noticias disponibles'));
          }
        },
      ),
    );
  }
}
