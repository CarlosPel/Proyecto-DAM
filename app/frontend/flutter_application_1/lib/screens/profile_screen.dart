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
        // automaticallyImplyLeading: false,
        title: const Text('Mi Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /*CircleAvatar(
              radius: 50,
              //backgroundImage: AssetImage(Icons.person),
            ),

            const SizedBox(height: 16.0),*/
            
            // Nombre de usuario
            FutureBuilder<Map<String, String>>(
              future: obtenerDatosUsuario(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error loading data');
                } else if (snapshot.hasData) {
                  return Text(
                    snapshot.data!['nombre'] ?? 'username',
                    style: Theme.of(context).textTheme.titleLarge,
                  );
                } else {
                  return const Text('No data available');
                }
              },
            ),

            const SizedBox(height: 8.0),

            // Correo electrónico
            Text(
              'userProfile.email', 
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 24.0),

            // Correo electrónico
            Text(
              'userProfile.country',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 24.0),

            // Botón para editar perfil
            ElevatedButton(
              onPressed: () {
                // Acción para editar perfil
              },
              child: const Text('Editar Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}
