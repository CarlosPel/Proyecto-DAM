class User {
  final int id;
  final String name;
  final String country;
  final List<dynamic> posts;
  final List<dynamic> comments;

  User({
    required this.id,
    required this.name,
    required this.country,
    required this.posts,
    required this.comments,
  });
}
