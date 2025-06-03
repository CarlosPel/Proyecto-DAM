import 'package:flutter_application_1/models/post.dart';

class User {
  final int id;
  final String name;
  final String country;
  final List<Post> posts;
  final List<Post> comments;

  User({
    required this.id,
    required this.name,
    required this.country,
    required this.posts,
    required this.comments,
  });
}
