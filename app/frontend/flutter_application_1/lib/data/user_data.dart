import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserData(dynamic responseData) async {
  // Guarda datos del usuario en shared preferences
  _saveUserData(
      name: responseData['user']['username'],
      email: responseData['user']['email'],
      countryCode: responseData['user']['nation'],
      token: responseData['token']);
}

// Función para guardar datos del usuario en SharedPreferences
Future<void> _saveUserData(
    {required String name,
    required String email,
    required String countryCode,
    required String token}) async {
  // Se obtiene una instancia de SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Se guardan los datos del usuario
  await prefs.setString('nombre', name);
  await prefs.setString('email', email);
  await prefs.setString('countryCode', countryCode);
  await prefs.setString('token', token);
}

// Función para obtener datos del usuario desde SharedPreferences
Future<Map<String, String>> getUserData() async {
  // Se obtiene una instancia de SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Se obtienen los datos del usuario
  String? nombre = prefs.getString('nombre');
  String? email = prefs.getString('email');
  String? countryCode = prefs.getString('countryCode');
  String? token = prefs.getString('token');

  return {
    'nombre': nombre ?? '',
    'email': email ?? '',
    'countryCode': countryCode ?? '',
    'token': token ?? '',
  };
}
