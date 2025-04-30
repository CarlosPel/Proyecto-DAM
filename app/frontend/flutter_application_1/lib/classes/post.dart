class Post {
  int id;
  String? title;
  String content;
  String datetime;
  String user;

  Post({
    required this.id,
    this.title,
    required this.content,
    required this.datetime,
    required this.user,
  });
}