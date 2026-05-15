import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hive/hive.dart';

class AdultoMayorPage extends StatefulWidget {
  const AdultoMayorPage({Key? key}) : super(key: key);

  @override
  State<AdultoMayorPage> createState() => _AdultoMayorPageState();
}

class _AdultoMayorPageState extends State<AdultoMayorPage> {
  final FlutterTts flutterTts = FlutterTts();

  late Box contactoBox;

  final TextEditingController nombreFamiliarCtrl =
  TextEditingController();

  final TextEditingController telefonoFamiliarCtrl =
  TextEditingController();

  final String consejoGeneral =
      "Modo adulto mayor. Recuerda medir tu glucosa, tomar tus medicamentos a horario, beber agua, alimentarte bien y moverte de forma segura. Si tienes mareos, confusión, sudor frío, dolor en el pecho, dificultad para respirar, heridas en los pies o glucosa muy baja o muy alta, pide ayuda de inmediato.";

  @override
  void initState() {
    super.initState();

    contactoBox = Hive.box('contactoEmergenciaBox');

    nombreFamiliarCtrl.text =
        contactoBox.get("nombre", defaultValue: "");

    telefonoFamiliarCtrl.text =
        contactoBox.get("telefono", defaultValue: "");
  }

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
    final limpio =
    numero.replaceAll(RegExp(r'[^0-9+]'), '');

    final Uri uri = Uri(
      scheme: 'tel',
      path: limpio,
    );

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  Widget configurarContacto() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Contacto de emergencia",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: nombreFamiliarCtrl,
              decoration: const InputDecoration(
                labelText: "Nombre familiar/cuidador",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: telefonoFamiliarCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Teléfono",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await contactoBox.put(
                    "nombre",
                    nombreFamiliarCtrl.text,
                  );

                  await contactoBox.put(
                    "telefono",
                    telefonoFamiliarCtrl.text,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Contacto guardado",
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text(
                  "Guardar contacto",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget botonEmergencia() {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const Icon(
              Icons.emergency,
              color: Colors.red,
              size: 60,
            ),

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
              style: TextStyle(
                fontSize: 20,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => llamar("131"),
                icon: const Icon(
                  Icons.local_hospital,
                  size: 30,
                ),
                label: const Text(
                  "Llamar ambulancia 131",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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
                onPressed: () => llamar(
                  telefonoFamiliarCtrl.text.isEmpty
                      ? "131"
                      : telefonoFamiliarCtrl.text,
                ),
                icon: const Icon(
                  Icons.phone,
                  size: 30,
                ),
                label: const Text(
                  "Llamar familiar",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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

  Widget tarjeta(
      String titulo,
      String texto,
      IconData icono,
      Color color,
      ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 9),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icono,
              size: 50,
              color: color,
            ),

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
                    onPressed: () =>
                        hablar("$titulo. $texto"),
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
        border: Border.all(
          color: Colors.purple.shade100,
        ),
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
                  onPressed: () =>
                      hablar(consejoGeneral),
                  icon: const Icon(Icons.volume_up),
                  label: const Text(
                    "Escuchar guía",
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: detenerVoz,
                  icon: const Icon(Icons.stop),
                  label: const Text("Detener"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
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

            configurarContacto(),

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
              "Prefiere comidas simples: verduras, proteínas, legumbres, lácteos sin azúcar y porciones moderadas.",
              Icons.restaurant,
              Colors.green,
            ),

            tarjeta(
              "Medicamentos",
              "Toma tus medicamentos a horario.",
              Icons.medication,
              Colors.pink,
            ),

            tarjeta(
              "Evitar caídas",
              "Usa buen calzado y buena iluminación.",
              Icons.elderly,
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}