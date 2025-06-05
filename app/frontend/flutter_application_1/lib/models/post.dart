import 'package:flutter_application_1/models/article.dart';
import 'package:flutter_application_1/enums/topic.dart';

// Contiene los campos de una publicación o comentario
class Post {
  // Número de identificación
  int? id;
  // Título. Los comentarios no tienen
  String? title;
  // Contenido de texto. Los comentarios no tienen
  String content;
  // Fecha y hora exactas de publicación
  String? datetime;
  // Nombre de usuario del autor
  String? author;
  // Noticia referenciada. Los comentarios no tienen
  Article? article;
  // Tema con el que se identifica. Los comentarios no tienen
  List<Topic>? topics;
  // Si es un comentario contiene el número de identificación
  // de la publicación padre
  int? parentPostId;

  // Constructor con los parámetros para todas las propiedades 
  // de la clase
  Post({
    this.id,
    this.title,
    required this.content,
    this.datetime,
    this.author,
    this.article,
    this.topics,
    this.parentPostId,
  });
}
