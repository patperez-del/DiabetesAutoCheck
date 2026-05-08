import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';

class AdultoMayorPage extends StatefulWidget {
  const AdultoMayorPage({Key? key}) : super(key: key);

  @override
  State<AdultoMayorPage> createState() => _AdultoMayorPageState();
}

class _AdultoMayorPageState extends State<AdultoMayorPage> {
  final FlutterTts flutterTts = FlutterTts();

  final String consejoGeneral =
      "Modo adulto mayor. Recuerda medir tu glucosa, tomar tus medicamentos a horario, beber agua, alimentarte bien y moverte de forma segura. Si tienes mareos, confusión, sudor frío, dolor en el pecho, dificultad para respirar, heridas en los pies o glucosa muy baja o muy alta, pide ayuda de inmediato.";

  Future<void> hablar(String texto) async {
    await flutterTts.setLanguage("es-ES");
    await flutterTts.setSpeechRate(0.42);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(texto);
  }

  Future<void> detenerVoz() async {
    await flutterTts.stop();
  }
  Future<void> llamar(String numero) async {
    final Uri uri = Uri(scheme: 'tel', path: numero);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print("No se pudo llamar");
    }
  }
  Widget botonEmergencia() {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const Icon(Icons.emergency, color: Colors.red, size: 60),
            const SizedBox(height: 8),
            const Text(
              "EMERGENCIA",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Si tienes dolor en el pecho, dificultad para respirar, confusión, desmayo, glucosa muy baja o muy alta, pide ayuda de inmediato.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, height: 1.4),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () =>
                    llamar("131"),
                icon: const Icon(Icons.local_hospital, size: 30),
                label: const Text(
                  "Llamar ambulancia 131",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () =>
                    llamar("912345678"),
                icon: const Icon(Icons.phone, size: 30),
                label: const Text(
                  "Llamar familiar",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tarjeta(String titulo, String texto, IconData icono, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 9),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icono, size: 50, color: color),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    texto,
                    style: const TextStyle(
                      fontSize: 20,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () => hablar("$titulo. $texto"),
                    icon: const Icon(Icons.volume_up),
                    label: const Text(
                      "Escuchar",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget alerta() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.purple.shade100),
      ),
      child: Column(
        children: [
          const Text(
            "Modo Adulto Mayor\n\n"
                "Consejos simples para cuidar la glucosa, evitar caídas, mantener fuerza, hidratarse y alimentarse mejor.",
            style: TextStyle(
              fontSize: 21,
              height: 1.4,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => hablar(consejoGeneral),
                  icon: const Icon(Icons.volume_up),
                  label: const Text("Escuchar guía"),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: detenerVoz,
                  icon: const Icon(Icons.stop),
                  label: const Text("Detener"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3FA),
      appBar: AppBar(
        title: const Text("Adulto Mayor"),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            alerta(),
            const SizedBox(height: 14),
            botonEmergencia(),

            tarjeta(
              "Glucosa",
              "Mide tu glucosa según indicación médica. Si está muy baja o muy alta, no lo ignores.",
              Icons.monitor_heart,
              Colors.red,
            ),
            tarjeta(
              "Alimentación",
              "Prefiere comidas simples: verduras, proteínas, legumbres, lácteos sin azúcar y porciones moderadas de pan, arroz o papas.",
              Icons.restaurant,
              Colors.green,
            ),
            tarjeta(
              "Hidratación",
              "Toma agua durante el día, aunque no tengas mucha sed. La deshidratación puede empeorar el estado general.",
              Icons.water_drop,
              Colors.blue,
            ),
            tarjeta(
              "Movimiento seguro",
              "Caminar, hacer ejercicios sentado, yoga suave o tai chi ayudan a la glucosa, equilibrio y ánimo.",
              Icons.directions_walk,
              Colors.orange,
            ),
            tarjeta(
              "Fuerza muscular",
              "Mantener músculo es muy importante. Ayuda a caminar mejor, evitar caídas y mejorar el control metabólico.",
              Icons.fitness_center,
              Colors.deepOrange,
            ),
            tarjeta(
              "Medicamentos",
              "Toma tus medicamentos a horario. No suspendas ni cambies dosis sin hablar con tu médico.",
              Icons.medication,
              Colors.pink,
            ),
            tarjeta(
              "Evitar caídas",
              "Usa buen calzado, buena luz en casa y evita alfombras sueltas. Levántate despacio.",
              Icons.elderly,
              Colors.purple,
            ),
            tarjeta(
              "Cuándo pedir ayuda",
              "Consulta si hay mareos, sudor frío, confusión, glucosa muy baja, glucosa muy alta, heridas en pies o visión borrosa.",
              Icons.warning_amber,
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}