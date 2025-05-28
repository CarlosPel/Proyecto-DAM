// Estado para almacenar las publicaciones ya cargadas
class UserPostsState {
  // Patrón Singleton para la clase PostsState
  // Se asegura de que solo haya una instancia de PostsState en toda la aplicación
  static final UserPostsState _instance = UserPostsState._internal();
  // Constructor privado para evitar la creación de instancias externas
  factory UserPostsState() => _instance;

  // Constructor interno para inicializar la instancia
  UserPostsState._internal();

  // Lista local para las noticias cargadas
  List<dynamic> posts = [];
}

final userPostsState = UserPostsState();
