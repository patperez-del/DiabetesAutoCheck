import 'package:flutter/material.dart';

class PesoPage extends StatefulWidget {
  const PesoPage({super.key});

  @override
  State<PesoPage> createState() => _PesoPageState();
}

class _PesoPageState extends State<PesoPage> {

  final TextEditingController pesoController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();

  double imc = 0;
  String estado = "";

  void calcularIMC() {

    double peso = double.parse(pesoController.text);
    double altura = double.parse(alturaController.text);

    setState(() {

      imc = peso / (altura * altura);

      if (imc < 18.5) {
        estado = "Bajo peso";
      } else if (imc < 25) {
        estado = "Normal";
      } else if (imc < 30) {
        estado = "Sobrepeso";
      } else {
        estado = "Obesidad";
      }

    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Peso e IMC"),
        backgroundColor: Colors.green,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: pesoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Peso (kg)",
              ),
            ),

            const SizedBox(height:20),

            TextField(
              controller: alturaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Altura (m)",
              ),
            ),

            const SizedBox(height:20),

            ElevatedButton(
              onPressed: calcularIMC,
              child: const Text("Calcular IMC"),
            ),

            const SizedBox(height:20),

            Text(
              "IMC: ${imc.toStringAsFixed(1)}",
              style: const TextStyle(fontSize:22),
            ),

            Text(
              estado,
              style: const TextStyle(fontSize:20,fontWeight: FontWeight.bold),
            ),

          ],

        ),

      ),

    );

  }

}