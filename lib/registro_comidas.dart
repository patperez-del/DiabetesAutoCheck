import 'package:flutter/material.dart';

class RegistroComidasPage extends StatelessWidget {

  final List<Map<String, dynamic>> comidas;

  const RegistroComidasPage({
    super.key,
    required this.comidas,
  });

  int caloriasTotales() {
    int total = 0;

    for (var comida in comidas) {
      total += comida["cal"] as int;
    }

    return total;
  }

  double cargaTotal() {
    double total = 0;

    for (var comida in comidas) {
      double ig = comida["ig"];
      double carb = comida["carb"];
      total += (ig * carb) / 100;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Comidas del día"),
      ),

      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              itemCount: comidas.length,
              itemBuilder: (context, index) {

                final comida = comidas[index];

                return ListTile(
                  title: Text(comida["nombre"]),
                  subtitle: Text("${comida["cal"]} kcal"),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "Calorías totales: ${caloriasTotales()} kcal",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            "Carga glucémica total: ${cargaTotal().toStringAsFixed(1)}",
            style: const TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 20),

        ],
      ),
    );
  }
}