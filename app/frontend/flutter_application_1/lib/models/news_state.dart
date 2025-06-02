// Estado para almacenar las noticias ya cargadas
class NewsState {
  // Patrón Singleton para la clase NewsState
  // Se asegura de que solo haya una instancia de NewsState en toda la aplicación
  static final NewsState _instance = NewsState._internal();
  // Constructor privado para evitar la creación de instancias externas
  factory NewsState() => _instance;

  // Constructor interno para inicializar la instancia
  NewsState._internal();

  // Lista local para las noticias cargadas
  List<dynamic> news = [];
}

final newsState = NewsState();
