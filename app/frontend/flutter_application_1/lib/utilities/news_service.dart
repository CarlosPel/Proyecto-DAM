import 'dart:convert';
import 'package:flutter_application_1/data/app_data.dart';
import 'package:http/http.dart' as http;

// Función para obtener las noticias principales
Future<List<dynamic>> fetchTopHeadlines(String? country) async {
  final String filter = '/top-headlines?country=$country&categoty=politics';
  return await _fetchNews(filter);
}

Future<List<dynamic>> _fetchNews(String filter) async {
  final String apiKey = AppData.apiKey;//dotenv.env['NEWS_API_KEY'];
  final String baseUrl = 'https://newsapi.org/v2';
  final String url = '$baseUrl$filter&apiKey=$apiKey';

  try {
    print(url);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      return data;
    } else {
      throw Exception('Error al obtener las noticias: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error de conexión: $e');
  }
}
