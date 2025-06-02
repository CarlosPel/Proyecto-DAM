class Article {
  String title;
  String? snippet;
  String? link;
  String? imgUrl;
  String? datetime;
  String? source;

  Article({
    required this.title,
    this.snippet,
    required this.link,
    this.imgUrl,
    required this.datetime,
    this.source,
  });
}