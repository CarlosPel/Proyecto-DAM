import 'package:shared_preferences/shared_preferences.dart';

Future<void> guardarDatosUsuario(dynamic responseData) async {
  // Guarda datos del usuario en shared preferences
  _guardarDatosUsuario(responseData['user']['username'],
      responseData['user']['email'], responseData['user']['nation']);
}

// Función para guardar datos del usuario en SharedPreferences
Future<void> _guardarDatosUsuario(
    String nombre, String email, String countryCode) async {
  // Se obtiene una instancia de SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Se guardan los datos del usuario
  await prefs.setString('nombre', nombre);
  await prefs.setString('email', email);
  await prefs.setString('countryCode', countryCode);
}

// Función para obtener datos del usuario desde SharedPreferences
Future<Map<String, String>> obtenerDatosUsuario() async {
  // Se obtiene una instancia de SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Se obtienen los datos del usuario
  String? nombre = prefs.getString('nombre');
  String? email = prefs.getString('email');
  String? countryCode = prefs.getString('countryCode');
  return {
    'nombre': nombre ?? '',
    'email': email ?? '',
    'countryCode': countryCode ?? '',
  };
}
