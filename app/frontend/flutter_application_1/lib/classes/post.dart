import 'package:flutter_application_1/classes/article.dart';
import 'package:flutter_application_1/enums/topic.dart';

class Post {
  int? id;
  String? title;
  String content;
  String? datetime;
  String? user;
  Article? article;
  Topic? topic;
  int? parentPostId;

  Post({
    this.id,
    this.title,
    required this.content,
    this.datetime,
    this.user,
    this.article,
    this.topic,
    this.parentPostId,
  });
}