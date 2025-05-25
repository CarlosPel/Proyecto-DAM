class Article {
  String title;
  String? snippet;
  String url;
  String? imgUrl;
  String datetime;
  String? source;

  Article({
    required this.title,
    this.snippet,
    required this.url,
    this.imgUrl,
    required this.datetime,
    this.source,
  });
}