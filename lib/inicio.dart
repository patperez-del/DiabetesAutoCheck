import 'package:flutter/material.dart';
import 'main.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({Key? key}) : super(key: key);

  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  final TextEditingController nombreController = TextEditingController();
  bool aceptaConsentimiento = false;
  bool aceptaPrivacidad = false;

  void ingresar() {
    if (nombreController.text.isEmpty ||
        !aceptaConsentimiento ||
        !aceptaPrivacidad) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Debes ingresar tu nombre y aceptar consentimiento y privacidad.',
          ),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardPage(),
      ),
    );
  }

  void verTextoLegal(String titulo, String texto) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(titulo),
          content: SingleChildScrollView(
            child: Text(texto),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const textoConsentimiento =
        'Declaro que entiendo que esta aplicación es una herramienta educativa '
        'y de registro personal. No reemplaza la evaluación médica, no entrega '
        'diagnóstico y no debe usarse para decisiones urgentes de salud.';

    const textoPrivacidad =
        'La información registrada en esta etapa se utiliza solo como apoyo '
        'para el autocontrol del usuario dentro de la app. Los datos de salud '
        'deben tratarse con respeto, confidencialidad y responsabilidad.';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 45),

            const Center(
              child: Icon(
                Icons.favorite,
                size: 70,
                color: Colors.pink,
              ),
            ),

            const SizedBox(height: 12),

            const Center(
              child: Text(
                'Mi Autochequeo Diabetes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Center(
              child: Text(
                'Autocontrol simple, visual y educativo',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 24),

            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre del usuario',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              '¿Qué es esta app?',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Mi Autochequeo Diabetes es una app pensada para ayudarte a tomar '
                  'el control de tu diabetes de forma sencilla, visual y sin '
                  'complicaciones técnicas. Funciona como una guía práctica de '
                  'autocontrol: te orienta a registrar tus datos, interpretar tus '
                  'resultados y detectar patrones que puedas comentar con tu equipo '
                  'de salud.',
              style: TextStyle(fontSize: 16, height: 1.4),
            ),

            const SizedBox(height: 18),

            const Text(
              'Con esta app podrás reflexionar sobre:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              '• Cómo se relacionan tus niveles de glucosa con lo que comes.\n'
                  '• El impacto de tu actividad física en tus mediciones.\n'
                  '• La importancia de la adherencia al tratamiento y tus hábitos diarios.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 18),

            const Text(
              'Mi Autochequeo Diabetes no reemplaza a tu médico ni a tus controles '
                  'presenciales. Es una herramienta de apoyo educativo para que llegues '
                  'mejor preparado a tus consultas, con más claridad sobre lo que está '
                  'pasando en tu día a día.',
              style: TextStyle(fontSize: 16, height: 1.4),
            ),

            const SizedBox(height: 20),

            const Text(
              'Funcionalidades principales',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              '• Guía de autocontrol.\n'
                  '• Formato visual y amigable.\n'
                  '• Reflexión guiada.\n'
                  '• Enfoque educativo.\n'
                  '• Registro personal de hábitos, glucosa, medicamentos y reportes.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3F8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.pink.shade100),
              ),
              child: const Text(
                'IMPORTANTE\n\n'
                    'Esta aplicación es una herramienta de apoyo educativo y de '
                    'registro personal. No ofrece diagnóstico médico, no sustituye '
                    'la consulta profesional ni debe utilizarse para tomar decisiones '
                    'urgentes sobre tu salud. Ante cualquier duda o síntoma, consulta '
                    'siempre con tu médico o servicio de urgencias.',
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
            ),

            const SizedBox(height: 18),

            CheckboxListTile(
              value: aceptaConsentimiento,
              onChanged: (value) {
                setState(() {
                  aceptaConsentimiento = value!;
                });
              },
              title: const Text('Acepto el consentimiento informado'),
              subtitle: GestureDetector(
                onTap: () => verTextoLegal(
                  'Consentimiento informado',
                  textoConsentimiento,
                ),
                child: const Text(
                  'Ver consentimiento informado',
                  style: TextStyle(
                    color: Colors.pink,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),

            CheckboxListTile(
              value: aceptaPrivacidad,
              onChanged: (value) {
                setState(() {
                  aceptaPrivacidad = value!;
                });
              },
              title: const Text('Acepto la política de privacidad de datos'),
              subtitle: GestureDetector(
                onTap: () => verTextoLegal(
                  'Privacidad de datos',
                  textoPrivacidad,
                ),
                child: const Text(
                  'Ver política de privacidad',
                  style: TextStyle(
                    color: Colors.pink,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: ingresar,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Ingresar a la app'),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}