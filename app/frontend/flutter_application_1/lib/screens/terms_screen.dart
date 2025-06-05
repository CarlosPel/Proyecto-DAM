import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/app_data.dart';
import 'package:flutter_application_1/services/user_data_service.dart';
import 'package:flutter_application_1/services/auth_service.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool _isAgreedWithTerms = false;
  bool _isAgreedWithPolicy = false;

  void _openPrivacyPolicy() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // permite full‐screen
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.95, // ocupa el 95% de la altura
        maxChildSize: 0.95,
        minChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              children: [
                // “pill” para arrastrar
                Container(
                  width: 100,
                  height: 5,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Política de Privacidad',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Última actualización: ${AppData.termsLastUpdateDate}',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'En ${AppData.appName}, tu privacidad es una prioridad. Esta Política de Privacidad explica cómo recopilamos, usamos, almacenamos y protegemos tu información personal al utilizar nuestra aplicación móvil.',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          '1. ¿Quiénes somos?',
                          style: TextStyle(fontSize: 16),
                        ),
                        const Text(
                          'Somos ${AppData.companyName}, responsables de la app ${AppData.appName}. Si tienes dudas o consultas relacionadas con esta política, puedes escribirnos a ${AppData.companyEmail}.',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '2. Información que recopilamos',
                          style: TextStyle(fontSize: 16),
                        ),
                        const Text(
                          'Información proporcionada por el usuario: \n'
                          ' - Nombre de usuario \n'
                          ' - Correo electrónico \n'
                          ' - País de residencia \n'
                          ' - Contraseña cifrada \n'
                          ' - Contenido generado (comentarios, publicaciones, etc.)\n'
                          'Información que recopilamos automáticamente: \n'
                          ' - Dirección IP \n'
                          ' - Tipo de dispositivo, sistema operativo y versión de la app \n'
                          ' - Fecha y hora de acceso \n'
                          ' - Interacciones dentro de la app (por ejemplo, con qué usuarios o contenido interactúas)',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '3. ¿Para qué usamos tu información?',
                          style: TextStyle(fontSize: 16),
                        ),
                        const Text(
                          ' - Para crear y gestionar tu cuenta \n'
                          ' - Para personalizar tu experiencia dentro de la red social \n'
                          ' - Para mejorar y optimizar la aplicación \n'
                          ' - Para enviarte notificaciones relevantes (solo si aceptas) \n'
                          ' - Para garantizar la seguridad y prevenir el uso indebido del servicio \n'
                          ' - Para cumplir con nuestras obligaciones legales',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '4. Base legal del tratamiento',
                          style: TextStyle(fontSize: 16),
                        ),
                        const Text(
                          'Tratamos tus datos de acuerdo con: \n'
                          ' - Tu consentimiento (al registrarte o aceptar cookies/notificaciones) \n'
                          ' - La ejecución de un contrato (al ofrecerte el servicio) \n'
                          ' - El interés legítimo (para mejorar la plataforma y evitar fraudes) \n'
                          ' - Obligaciones legales (por ejemplo, responder a requerimientos judiciales)',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '5. ¿Compartimos tu información?',
                          style: TextStyle(fontSize: 16),
                        ),
                        const Text(
                          'No vendemos ni alquilamos tu información personal. \n'
                          'Podemos compartirla únicamente con: \n'
                          ' - Proveedores de servicios técnicos que nos ayudan a operar la app (como servicios de hosting, bases de datos o análisis) \n'
                          ' - Autoridades legales cuando estemos obligados por ley \n'
                          'En todos los casos, exigimos a estos terceros que cumplan estándares de privacidad y seguridad equivalentes a los nuestros.',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '6. Seguridad de los datos',
                          style: TextStyle(fontSize: 16),
                        ),
                        const Text(
                          'Implementamos medidas técnicas y organizativas para proteger tu información, como: \n'
                          ' - Cifrado de contraseñas (hash seguro) \n'
                          ' - Comunicación cifrada (HTTPS) \n'
                          ' - Control de acceso a servidores \n'
                          'Aunque hacemos todo lo posible, ninguna transmisión por internet es 100% segura. Si detectas actividad sospechosa, contáctanos de inmediato.',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '7. Tus derechos',
                          style: TextStyle(fontSize: 16),
                        ),
                        const Text(
                          'Puedes ejercer los siguientes derechos:'
                          ' - Acceder a tus datos personales \n'
                          ' - Rectificar información incorrecta \n'
                          //' - Eliminar tu cuenta y datos personales \n'
                          ' - Limitar u oponerte al uso de tus datos \n'
                          ' - Portar tus datos a otro servicio (cuando sea técnicamente posible) \n'
                          'Para ejercer estos derechos, contáctanos desde la app o por correo a ${AppData.companyEmail}.',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '8. Retención de datos',
                          style: TextStyle(fontSize: 16),
                        ),
                        const Text(
                          'Conservamos tus datos mientras tu cuenta esté activa. Si decides eliminarla, eliminaremos o anonimizaremos tus datos de forma segura, salvo que debamos conservarlos por motivos legales.',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '9. Uso por menores de edad',
                          style: TextStyle(fontSize: 16),
                        ),
                        const Text(
                          'Nuestra app no está dirigida a menores de 14 años. Si eres menor de esa edad, no deberías registrarte ni utilizar nuestros servicios sin consentimiento parental. \nSi descubrimos que hemos recopilado datos de un menor sin autorización, los eliminaremos de inmediato.',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '10. Cambios en esta política',
                          style: TextStyle(fontSize: 16),
                        ),
                        const Text(
                          'Podemos actualizar esta Política ocasionalmente. Te informaremos dentro de la app o por correo si los cambios son significativos.',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '11. Contacto',
                          style: TextStyle(fontSize: 16),
                        ),
                        const Text(
                          'Si tienes dudas sobre esta política o deseas ejercer tus derechos, contáctanos en: ${AppData.companyEmail}',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Términos y Condiciones',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Última actualización: ${AppData.termsLastUpdateDate}',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Bienvenido a ${AppData.appName}. Estos términos y condiciones regulan el acceso y uso de nuestra aplicación móvil, disponible en plataformas iOS y Android. Al registrarte o utilizar nuestros servicios, aceptas quedar vinculado a estos términos.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              const Text(
                '1. Aceptación de los términos',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                'Al acceder, descargar o usar nuestra aplicación, reconoces que has leído, entendido y aceptado estar sujeto a estos términos. Si no estás de acuerdo con ellos, por favor no utilices la aplicación.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                '2. Registro de usuario',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                'Eres responsable de mantener la confidencialidad de tus credenciales de acceso. Notifícanos de inmediato si sospechas de un acceso no autorizado',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                '3. Uso adecuado de la aplicación',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                'Como usuario, te comprometes a: \n'
                ' - No usar la app con fines ilegales o no autorizados. \n'
                ' - No acosar, intimidar, difamar ni amenazar a otros usuarios. \n'
                ' - No compartir contenido ofensivo, discriminatorio, sexualmente explícito, violento o que infrinja derechos de terceros. \n'
                ' - No usar bots, scrapers o sistemas automatizados para acceder o recolectar datos de otros usuarios sin su consentimiento. \n'
                ' - No realizar ingeniería inversa ni intentar dañar la infraestructura de la aplicación.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                '4. Contenido generado por el usuario',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                'Nuestra app permite subir contenido (textos, comentarios, etc.). Eres responsable del contenido que publiques y declaras que tienes los derechos sobre él. \nNos reservas el derecho no exclusivo, transferible y sublicenciable para usar, reproducir, modificar y distribuir dicho contenido solo con fines operativos dentro de la plataforma. \nPodremos eliminar contenido que infrinja estos términos sin previo aviso.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                '5. Privacidad y protección de datos',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                'Valoramos tu privacidad. Recopilamos y tratamos tu información personal conforme a nuestra Política de Privacidad (*). \nEntre los datos que podemos recoger se incluyen: nombre, correo electrónico, país, contenidos subidos, preferencias y datos de uso. \nNo compartimos tus datos con terceros sin tu consentimiento, salvo requerimientos legales o integraciones necesarias para el funcionamiento del servicio.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                '6. Suspensión o cancelación de cuentas',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                'Nos reservamos el derecho de suspender o eliminar tu cuenta si violas estos términos, causas daño a la comunidad, a otros usuarios o al funcionamiento del servicio. ',
                //'Puedes eliminar tu cuenta en cualquier momento desde la configuración de la aplicación.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                '7. Cambios en los términos',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                'Podemos modificar estos términos ocasionalmente. Te notificaremos los cambios relevantes y, si continúas usando la app después de ser notificado, consideramos que aceptas las nuevas condiciones.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                '8. Limitación de responsabilidad',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                'El uso de la app se realiza bajo tu propio riesgo. No garantizamos que el servicio esté libre de errores o interrupciones. \nNo somos responsables de daños indirectos, pérdida de datos o conflictos entre usuarios derivados del uso de la plataforma.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                '9. Propiedad intelectual',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                'Todo el contenido, marca, nombre, logotipos, diseño y código fuente de la aplicación son propiedad de ${AppData.companyName}, salvo el contenido generado por los usuarios. \nNo puedes copiar, modificar, distribuir ni comercializar ningún elemento sin permiso explícito.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                '10. Legislación aplicable',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                'Estos términos se rigen por las leyes de Madrid, Comunidad de Madrid, España. Cualquier disputa será resuelta en los tribunales correspondientes de dicha jurisdicción.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                '11. Contacto',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                'Para preguntas o soporte, contáctanos a través del correo: ${AppData.companyEmail} o desde el apartado de soporte en la aplicación.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _openPrivacyPolicy,
                child: Text(
                  '* Ver Política de Privacidad',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _isAgreedWithTerms,
                    onChanged: (isAgreed) {
                      setState(() {
                        _isAgreedWithTerms = isAgreed!;
                      });
                    },
                  ),
                  Expanded(
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            _isAgreedWithTerms = !_isAgreedWithTerms;
                          });
                        },
                        child: const Text(
                            'He leído y acepto los términos y condiciones',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black))),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isAgreedWithPolicy,
                    onChanged: (isAgreed) {
                      setState(() {
                        _isAgreedWithPolicy = isAgreed!;
                      });
                    },
                  ),
                  Expanded(
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            _isAgreedWithPolicy = !_isAgreedWithPolicy;
                          });
                        },
                        child: Text(
                            'Estoy de acuerdo con la política de privacidad',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black))),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  spacing: 16,
                  children: [
                    ElevatedButton(
                      onPressed: () => logout(context),
                      child: const Text('Cerrar Sesión'),
                    ),
                    ElevatedButton(
                      onPressed: _isAgreedWithTerms & _isAgreedWithPolicy
                          ? () => agreeTerms(context)
                          : null,
                      child: const Text('Aceptar'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
