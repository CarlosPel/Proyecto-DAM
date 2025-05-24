import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserData(dynamic responseData) async {
  _saveUserData(
      name: responseData['user']['username'],
      email: responseData['user']['email'],
      countryCode: responseData['user']['nation'],
      token: responseData['token'],
      hasAgreed: responseData['user']['hasAgreed']);
}

// Guarda los datos del usuario en SharedPreferences
Future<void> _saveUserData(
    {required String name,
    required String email,
    required String countryCode,
    required String token,
    required bool hasAgreed}) async {
  // Se obtiene una instancia de SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Guarda los datos del usuario
  await prefs.setString('nombre', name);
  await prefs.setString('email', email);
  await prefs.setString('countryCode', countryCode);
  await prefs.setString('token', token);
  await prefs.setBool('hasAgreed', hasAgreed);
  await prefs.setBool('isLoggedIn', true);
}

// Obtener el token del usuario desde SharedPreferences
Future<String?> getUserToken() async {
  // Instancia de SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Token del usuario
  String? token = prefs.getString('token');

  return token;
}

// Obtener datos del usuario desde SharedPreferences
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

Future<bool> isLoggedIn() async {
  // Se obtiene una instancia de SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Se obtiene el estado de inicio de sesión
  bool? isLoggedIn = prefs.getBool('isLoggedIn');

  return isLoggedIn ?? false;
}

Future<void> logout() async {
  // Se obtiene una instancia de SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Se eliminan los datos del usuario
  await prefs.remove('nombre');
  await prefs.remove('email');
  await prefs.remove('countryCode');
  await prefs.remove('token');
  await prefs.remove('hasAgreed');
  await prefs.setBool('isLoggedIn', false);
}

Future<bool?> hasAgreed() async {
  // Se obtiene una instancia de SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Se obtiene el estado de acuerdo
  bool? hasAgreed = prefs.getBool('hasAgreed');

  return hasAgreed;
}

Future<void> saveAgreement() async {
  // Se obtiene una instancia de SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Se guarda el estado de acuerdo
  prefs.setBool('hasAgreed', true);
}

Future<bool> isDataSaved(Future<dynamic> getData) async {
  if (await getData != null) {
    return true;
  } else {
    return false;
  }
}
