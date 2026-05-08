import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SuenoPage extends StatefulWidget {
  const SuenoPage({Key? key}) : super(key: key);

  @override
  State<SuenoPage> createState() => _SuenoPageState();
}

class _SuenoPageState extends State<SuenoPage> {
  double horas = 7;
  String calidad = "Buena";
  final TextEditingController notaController = TextEditingController();

  late Box box;

  @override
  void initState() {
    super.initState();
    box = Hive.box('suenobox');

    horas = box.get('horas', defaultValue: 7.0);
    calidad = box.get('calidad', defaultValue: "Buena");
    notaController.text = box.get('nota', defaultValue: "");
  }

  void guardar() {
    box.put('horas', horas);
    box.put('calidad', calidad);
    box.put('nota', notaController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Sueño guardado")),
    );
  }

  String explicacion() {
    return "Dormir mal puede aumentar la glucosa, el apetito y el estrés. "
        "Dormir bien ayuda al control metabólico y al bienestar general.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sueño"),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "🛌 Horas dormidas",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            Slider(
              value: horas,
              min: 0,
              max: 12,
              divisions: 12,
              label: horas.toString(),
              onChanged: (value) {
                setState(() {
                  horas = value;
                });
              },
            ),

            Text("${horas.toStringAsFixed(0)} horas"),

            const SizedBox(height: 20),

            DropdownButton<String>(
              value: calidad,
              isExpanded: true,
              items: ["Mala", "Regular", "Buena"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  calidad = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            TextField(
              controller: notaController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Notas",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: guardar,
              icon: const Icon(Icons.save),
              label: const Text("Guardar"),
            ),

            const SizedBox(height: 20),

            Text(
              explicacion(),
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}