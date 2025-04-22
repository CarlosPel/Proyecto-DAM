import 'dart:convert';
import 'package:flutter_application_1/data/app_data.dart';
import 'package:http/http.dart' as http;

// Función para obtener las noticias principales
Future<List<dynamic>> fetchTopHeadlines(userData, {String country = 'us'}) async {
  final String url = '/top-headlines?country=$country&apiKey=';
  return await _fetchNews(url);
}

Future<List<dynamic>> _fetchNews(String url) async {
  final String apiKey = AppData.apiKey;//dotenv.env['NEWS_API_KEY'];
  final String baseUrl = 'https://newsapi.org/v2';
  final String fullUrl = '$baseUrl$url$apiKey';

  try {
    final response = await http.get(Uri.parse(fullUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['articles']; // Retorna la lista de artículos
    } else {
      throw Exception('Error al obtener las noticias: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error de conexión: $e');
  }
}
