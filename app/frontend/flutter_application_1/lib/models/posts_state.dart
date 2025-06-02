// Estado para almacenar las publicaciones ya cargadas
class PostsState {
  // Patrón Singleton para la clase PostsState
  // Se asegura de que solo haya una instancia de PostsState en toda la aplicación
  static final PostsState _instance = PostsState._internal();
  // Constructor privado para evitar la creación de instancias externas
  factory PostsState() => _instance;

  // Constructor interno para inicializar la instancia
  PostsState._internal();

  // Lista local para las noticias cargadas
  List<dynamic> posts = [];
}

final postsState = PostsState();
