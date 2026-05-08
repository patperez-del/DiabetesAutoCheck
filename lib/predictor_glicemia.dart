import 'package:flutter/material.dart';

class PredictorGlicemiaPage extends StatefulWidget {
  const PredictorGlicemiaPage({super.key});

  @override
  State<PredictorGlicemiaPage> createState() => _PredictorGlicemiaPageState();
}

class _PredictorGlicemiaPageState extends State<PredictorGlicemiaPage> {
  final igController = TextEditingController();
  final carbController = TextEditingController();

  double carga = 0;
  String clasificacion = "";
  String impacto = "";

  void calcular() {
    final ig = double.tryParse(igController.text) ?? 0;
    final carb = double.tryParse(carbController.text) ?? 0;

    setState(() {
      carga = (ig * carb) / 100;

      if (carga <= 10) {
        clasificacion = "🟢 Carga glucémica baja";
        impacto = "Impacto leve en glucosa a 2 horas";
      } else if (carga < 20) {
        clasificacion = "🟠 Carga glucémica moderada";
        impacto = "Impacto moderado en glucosa a 2 horas";
      } else {
        clasificacion = "🔴 Carga glucémica alta";
        impacto = "Impacto alto en glucosa a 2 horas";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Predictor de glicemia"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: igController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Índice glucémico",
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: carbController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Carbohidratos (g)",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: calcular,
              child: const Text("Calcular impacto"),
            ),

            const SizedBox(height: 30),

            Text(
              "Carga glucémica: ${carga.toStringAsFixed(1)}",
              style: const TextStyle(fontSize: 22),
            ),

            const SizedBox(height: 10),

            Text(
              clasificacion,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              impacto,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
