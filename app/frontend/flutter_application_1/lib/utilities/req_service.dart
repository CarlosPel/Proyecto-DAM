import 'dart:convert';
import 'package:flutter_application_1/data/app_data.dart';
import 'package:flutter_application_1/data/user_data.dart';
import 'package:http/http.dart' as http;

const String politicsCode =
    'CAAqIQgKIhtDQkFTRGdvSUwyMHZNRFZ4ZERBU0FtVnpLQUFQAQ';
const String backendUrl = AppData.backendUrl;

// Noticias más relevantes de política del país del usuario ordenadas por ultima hora
Future<List<dynamic>> fetchTopHeadlines(String? country) async {
  final String url =
      '/topic-headlines?topic=$politicsCode&country=$country&lang=es';
  return await _fetchNews(url);
}

// Obtiene posts
Future<List<dynamic>> fetchPosts(String? country) async {
  final String routeUrl = '$backendUrl/posts/get';
  final String userToken = await getUserToken();

  return await _fetchFromReq(http.post(
    Uri.parse(routeUrl),
    headers: {
      'Authorization': 'Bearer $userToken',
      'Content-Type': 'application/json'
    },
    body: jsonEncode({'nation': country}),
  ));
}

// Obtiene los comentarios de un post
Future<List<dynamic>> fetchComments(int postId) async {
  final String routeUrl = '$backendUrl/posts/comments';

  return await _fetchFromReq(http.post(
    Uri.parse(routeUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'id_post': postId}),
  ));
}

// Obtiene las noticias de la url proporcionada
Future<List<dynamic>> _fetchNews(String url) async {
  // final String routeUrl = '$backendUrl/news/get';
  return _fetchFakeNews();
  /*return await _fetchFromReq(http.post(
    Uri.parse(routeUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'urlFi': url}),
  ));*/
}

// Devuelve noticias de ejemplo para no consumir la API
// Borrar para versión de producción
List<dynamic> _fetchFakeNews() {
  final List<dynamic> fakenews = [];
  for (int i = 0; i < 100; i++) {
    fakenews.add({
      'title': 'Noticia de ejemplo $i',
      'snippet': 'Esta es una noticia de ejemplo $i.',
      'link': 'https://example.com/noticia-$i',
      'photo_url': 'https://example.com/foto-$i.jpg',
      'published_datetime_utc': DateTime.now().toUtc().toString(),
      'source_name': 'Fuente de ejemplo $i',
    });
  }
  return fakenews;
}

// Obtiene las noticias de la url proporcionada
Future<List<dynamic>> _fetchFromReq(Future<http.Response> req) async {
  try {
    final response = await req;
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Error al cargar el contenido: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error de conexión: $e');
  }
}
