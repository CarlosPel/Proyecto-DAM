import 'package:shared_preferences/shared_preferences.dart';

// Función para guardar datos del usuario en SharedPreferences
Future<void> guardarDatosUsuario(String nombre, String email, String countryCode) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('nombre', nombre);
  await prefs.setString('email', email);
  await prefs.setString('countryCode', countryCode);
}

// Función para obtener datos del usuario desde SharedPreferences
Future<Map<String, String>> obtenerDatosUsuario() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? nombre = prefs.getString('nombre');
  String? email = prefs.getString('email');
  String? countryCode = prefs.getString('countryCode');
  return {
    'nombre': nombre ?? '',
    'email': email ?? '',
    'countryCode': countryCode ?? '',
  };
}