import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/user_data.dart';
import 'package:flutter_application_1/utilities/auth_service.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Términos y Condiciones'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Términos y Condiciones',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Bienvenido a nuestra aplicación. Al utilizar este servicio, aceptas los siguientes términos y condiciones:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                '1. Uso adecuado: Debes utilizar la aplicación de manera responsable y conforme a la ley.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                '2. Privacidad: Respetamos tu privacidad y protegemos tus datos personales.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                '3. Cambios: Nos reservamos el derecho de modificar estos términos en cualquier momento.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Si tienes preguntas, contáctanos a través del soporte de la aplicación.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _isAgreed,
                    onChanged: (isAgreed) {
                      setState(() {
                        _isAgreed = isAgreed!;
                      });
                    },
                  ),
                  const Text('He leído y acepto los términos y condiciones'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      logout(context);
                    },
                    child: const Text('Cerrar Sesión'),
                  ),
                  const SizedBox(width: 32),
                  !_isAgreed
                      ? ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Aceptar'),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            agreeTerms(context);
                          },
                          child: const Text('Aceptar'),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
