import 'package:flutter/material.dart';
import 'package:flutter_application_1/clases/user_profile.dart';
import 'package:flutter_application_1/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final UserProfile userProfile = Provider.of<UserProvider>(context).user!;

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
            Text(
              userProfile.username,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8.0),
            Text(
              userProfile.email,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24.0),
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
