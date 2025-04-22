import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/user_data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        // FutureBuilder para cargar los datos del usuario
        child: FutureBuilder<Map<String, String>>(
          future: getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error al cargar los datos'));
            } else if (snapshot.hasData) {
              final userData = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar del usuario
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
                  const SizedBox(height: 16.0),

                  // Nombre de usuario
                  Text(
                    userData['nombre'] ?? 'Nombre no disponible',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8.0),

                  // Correo electrónico
                  Text(
                    userData['email'] ?? 'Correo no disponible',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8.0),

                  // País
                  CountryCodePicker(
                    enabled: false,
                    onChanged: (code) {},
                    initialSelection: userData['countryCode'] ?? 'ES',
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    comparator: (a, b) => b.name!.compareTo(a.name!),
                    onInit: (code) {
                      code!.name = code.code == 'ES' ? 'España' : code.name;
                      /*debugPrint(
                        "on init ${code?.name} ${code?.dialCode} ${code?.name}");*/
                      /*print('insert into nation (code, nation_name) values\n');
                    for (var country in codes) {
                      print('(\'${country['code']}\', \'${country['name']}\'),');
                    }*/
                    },
                    showCountryOnly: true,
                    showOnlyCountryWhenClosed: true,
                  ),
                  /*Text(
                    userData['countryCode'] ?? 'País no disponible',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24.0),*/

                  // Botón para editar perfil
                  ElevatedButton(
                    onPressed: () {
                      // Acción para editar perfil
                    },
                    child: const Text('Editar Perfil'),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No hay datos disponibles'));
            }
          },
        ),
      ),
    );
  }
}
