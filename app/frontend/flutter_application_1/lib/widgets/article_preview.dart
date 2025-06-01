import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Widget para la previsualización de las noticias
// Los stateless widgets no cambian tras su creación en la pantalla
class ArticlePreview extends StatelessWidget {
  // Título de la noticia
  final String title;
  // Fuente de la noticia
  final String? source;
  // Día y hora de publicación de la noticia
  final String? datetime;
  
  const ArticlePreview(
      {super.key, required this.title, this.source, this.datetime});

  // Muestra los elementos del Widget
  @override
  Widget build(BuildContext context) {
    // Da formato español a la fecha de publicación
    final formattedDate = DateFormat.yMMMMd('es_ES')
      .format(datetime != null ? DateTime.parse(datetime!) : DateTime.now());
      
    // Elemento que se visualiza al llamar a la clase
    return Column(
      // Alinea los hijos a arriba a la izquerda
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Contenedor del título de la noticia
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        // Línea horizontal gris de separación
        Container(color: Colors.grey,width: double.infinity, height: 2,),
        const SizedBox(height: 3),
        // Contenedor horizontal para la fuente y la fecha
        Row(
          children: [
            // Contenedor de la fuente de la noticia
            Text(
              source ?? 'Fuente desconocida',
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
            // Ocupa todo el espacio de su contenedor padre que no esten 
            // usando el resto de hijos, separando los textos a los extremos
            const Spacer(),
            // Contenedor de la fecha de publicación de la noticia
            Text(
              formattedDate,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 3),
        // Línea horizontal gris de separación
        Container(color: Colors.grey,width: double.infinity, height: 2,),
      ],
    );
  }
}
