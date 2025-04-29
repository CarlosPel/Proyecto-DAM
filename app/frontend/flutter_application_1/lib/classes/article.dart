class Article {
  String title;
  String? snippet;
  String url;
  String imgUrl;
  String datetime;
  String source;

  Article({
    required this.title,
    this.snippet,
    required this.url,
    required this.imgUrl,
    required this.datetime,
    required this.source,
  });
}