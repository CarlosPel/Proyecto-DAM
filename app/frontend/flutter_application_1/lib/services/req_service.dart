import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_data.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/services/user_data_service.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:http/http.dart' as http;

const String politicsCode =
    'CAAqIQgKIhtDQkFTRGdvSUwyMHZNRFZ4ZERBU0FtVnpLQUFQAQ';
const String backendUrl = AppData.backendUrl;

Future<User> getUserByName(BuildContext context, String name) async {
  final String getUserUrl = '$backendUrl/user/get';
  try {
    final String? token = await getToken();

    final response = await http.post(
      Uri.parse(getUserUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );
    if (handleResponse(
      context: context,
      response: response,
      onSuccess: (responseData) async {
        return true;
      },
    )) {
      return jsonDecode(response.body)['data'];
    } else {
      return User(id: 0, name: '', country: '', posts: [], comments: []);
    }
  } catch (e) {
    // Manejar errores de conexión
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error de conexión: $e')),
    );
    return User(id: 0, name: '', country: '', posts: [], comments: []);
  }
}

// Noticias más relevantes de política del país del usuario ordenadas por ultima hora
Future<List<dynamic>> fetchTopHeadlines(String? country) async {
  final String url =
      '/topic-headlines?topic=$politicsCode&country=$country&lang=es';
  return await _fetchNews(url);
}

// Obtiene posts
Future<List<dynamic>> fetchPosts(BuildContext context, String? country) async {
  final String routeUrl = '$backendUrl/posts/get';
  final String userToken = (await getToken())!;

  return await _fetchFromReq(
      context,
      http.post(
        Uri.parse(routeUrl),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'nation': country}),
      ));
}

Future<List<dynamic>> fetchUserPosts(BuildContext context) async {
  final String routeUrl = '$backendUrl/users/userposts';
  final String userToken = (await getToken())!;

  return await _fetchFromReq(
      context,
      http.post(
        Uri.parse(routeUrl),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json'
        },
      ));
}

// Obtiene los comentarios de un post
Future<List<dynamic>> fetchComments(BuildContext context, int postId) async {
  final String routeUrl = '$backendUrl/posts/comments';

  return await _fetchFromReq(
      context,
      http.post(
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
      'title': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'snippet':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. ',
      //Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      'link': 'https://matchlyric.com/kanye-west-hh-traduccion-al-espanol',
      'photo_url':
          'https://mbblancabelzunce.com/wp-content/uploads/2024/05/360_F_419176802_9s4AoYMfzxDt3kaSYV55whCkTB76NsHN.jpg',
      'published_datetime_utc': DateTime.now().toUtc().toString(),
      'source_name': 'Fuente de ejemplo $i',
    });
  }
  return fakenews;
}

// Obtiene las noticias de la url proporcionada
Future<List<dynamic>> _fetchFromReq(
    BuildContext context, Future<http.Response> req) async {
  final response = await req;

  if (handleResponse(
    context: context,
    response: response,
    onSuccess: (responseData) async {
      return true;
    },
  )) {
    return jsonDecode(response.body)['data'];
  } else {
    return [];
  }
}
