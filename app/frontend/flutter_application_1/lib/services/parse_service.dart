import 'package:flutter_application_1/models/article.dart';
import 'package:flutter_application_1/models/post.dart';

Post parsePost(dynamic postData) {
  return Post(
    id: postData['id_post'],
    title: postData['title'],
    content: postData['content'],
    datetime: postData['post_date'],
    author: postData['user_name'],
    parentPostId: postData['parent_post'],
    article: postData['noticia_title'] != null
        ? Article(
            title: postData['noticia_title'],
            snippet: postData['noticia_content'],
            datetime: postData['noticia_fecha'],
            source: postData['noticia_source'],
            link: postData['noticia_link'],
          )
        : null,
  );
}
