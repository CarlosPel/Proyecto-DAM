import 'dart:convert';
import 'package:http/http.dart' as http;

const String politicsCode = 'CAAqIQgKIhtDQkFTRGdvSUwyMHZNRFZ4ZERBU0FtVnpLQUFQAQ';

// Noticias más relevantes de política del país del usuario ordenadas por ultima hora
Future<List<dynamic>> fetchTopHeadlines(String? country) async {
  final String url =
      '/topic-headlines?topic=$politicsCode&country=ES&lang=es';
  return await _fetchNews(url);
}

// Obtiene las noticias de la url proporcionada
Future<List<dynamic>> _fetchNews(String url) async {
  final String loginUrl = 'http://10.0.2.2:5000/news/get';
  try {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'urlFi': url}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Error al cargar las noticias: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error de conexión: $e');
  }
}
