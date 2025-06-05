import 'package:flutter_application_1/models/article.dart';
import 'package:flutter_application_1/models/post.dart';

Post parsePost(dynamic postData, {String? username, dynamic article}) {
  return Post(
    id: postData['id_post'],
    title: postData['title'],
    content: postData['content'],
    datetime: postData['post_date'],
    author: username ?? postData['user_name'],
    parentPostId: postData['parent_post'],
    article: article != null
        ? Article(
            title: article['noticia_title'],
            snippet: article['noticia_content'],
            datetime: article['noticia_fecha'],
            source: article['noticia_source'],
            link: article['noticia_link'],
          )
        : postData['noticia_title'] != null
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
