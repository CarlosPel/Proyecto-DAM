import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_data.dart';
import 'package:flutter_application_1/enums/topic.dart';
import 'package:flutter_application_1/models/post.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/services/handle_respones.dart';
import 'package:flutter_application_1/services/parse_service.dart';
import 'package:flutter_application_1/services/user_data_service.dart';
import 'package:http/http.dart' as http;

const String politicsCode =
    'CAAqIQgKIhtDQkFTRGdvSUwyMHZNRFZ4ZERBU0FtVnpLQUFQAQ';
const String backendUrl = AppData.backendUrl;

Future<User> getUserByName(BuildContext context, String name) async {
  final String getUserUrl = '$backendUrl/users/otheruser';

  try {
    final response = await http.post(Uri.parse(getUserUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': name}));

    if (handleResponse(
      context: context,
      response: response,
      onSuccess: (responseData) async {
        return true;
      },
    )) {
      final userData = jsonDecode(response.body)['data'];
      final userPosts = jsonDecode(response.body)['posts'];
      final userComments = jsonDecode(response.body)['comments'];

      return User(
          id: userData['id_user'],
          name: userData['username'],
          country: userData['nation'],
          posts: userPosts,
          comments: userComments);
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
Future<List<dynamic>> fetchTopHeadlines(BuildContext context, String? country) async {
  final String url =
      '/topic-headlines?topic=$politicsCode&country=$country&lang=es';
  return await _getNews(context, url);
}

Future<Post> getOlderPost(BuildContext context, int id) async {
  final String getUserUrl = '$backendUrl/posts/parentpost';

  try {
    final response = await http.post(Uri.parse(getUserUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_post': id}));

    if (handleResponse(
      context: context,
      response: response,
      onSuccess: (responseData) async {
        return true;
      },
    )) {
      return parsePost(jsonDecode(response.body)['data'],
          username: jsonDecode(response.body)['user'],
          article: jsonDecode(response.body)['noticia']);
    }
    return Post(content: '');
  } catch (e) {
    // Manejar errores de conexión
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error de conexión: $e')),
    );
    return Post(content: '');
  }
}

Future<List<dynamic>> getFollowingPosts(BuildContext context) async {
  final String routeUrl = '$backendUrl/posts/getfollowed';
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

Future<List<dynamic>> getTopicsPosts(
    BuildContext context, List<Topic> topics) async {
  final String routeUrl = '$backendUrl/posts/getpostsbytopic';
  final String userToken = (await getToken())!;

  return await _fetchFromReq(
      context,
      http.post(
        Uri.parse(routeUrl),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'topics': topics.map((t) => t.name).toList()}),
      ));
}

// Obtiene posts
Future<List<dynamic>> getPosts(BuildContext context, {String? country}) async {
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

Future<List<dynamic>> getUserComments(BuildContext context) async {
  final String routeUrl = '$backendUrl/users/usercomments';
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

Future<List<dynamic>> getUserSavedPosts(BuildContext context) async {
  final String routeUrl = '$backendUrl/users/savedposts';
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

Future<List<dynamic>> getUserPosts(BuildContext context) async {
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
Future<List<dynamic>> getComments(BuildContext context, int postId) async {
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
Future<List<dynamic>> _getNews(BuildContext context, String url) async {
  final String routeUrl = '$backendUrl/news/get';
  // return _fetchFakeNews();
  return await _fetchFromReq(context, http.post(
    Uri.parse(routeUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'urlFi': url}),
  ));
}

// Devuelve noticias de ejemplo para no consumir la API
// Borrar para versión de producción
// List<dynamic> _fetchFakeNews() {
//   final List<dynamic> fakenews = [];
//   for (int i = 0; i < 100; i++) {
//     fakenews.add({
//       'title': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
//       'snippet':
//           'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. ',
//       //Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
//       'link': 'https://matchlyric.com/kanye-west-hh-traduccion-al-espanol',
//       'photo_url':
//           'https://mbblancabelzunce.com/wp-content/uploads/2024/05/360_F_419176802_9s4AoYMfzxDt3kaSYV55whCkTB76NsHN.jpg',
//       'published_datetime_utc': DateTime.now().toUtc().toString(),
//       'source_name': 'Fuente de ejemplo $i',
//     });
//   }
//   return fakenews;
// }

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
      showErrMessage: false)) {
    return jsonDecode(response.body)['data'];
  } else {
    return [];
  }
}
