import 'package:flutter/material.dart';

class RiesgoPage extends StatefulWidget {
  const RiesgoPage({Key? key}) : super(key: key);

  @override
  State<RiesgoPage> createState() => _RiesgoPageState();
}

class _RiesgoPageState extends State<RiesgoPage> {
  final glucosaController = TextEditingController();
  final presionController = TextEditingController();
  final edadController = TextEditingController();

  String resultado = "";
  Color color = Colors.grey;

  void evaluar() {
    final glucosa = double.tryParse(glucosaController.text) ?? 0;
    final presion = double.tryParse(presionController.text) ?? 0;
    final edad = double.tryParse(edadController.text) ?? 0;

    setState(() {
      if (glucosa > 250 || presion > 180) {
        resultado = "🔴 Riesgo ALTO\nConsulta urgente";
        color = Colors.red;
      } else if (glucosa > 180 || presion > 140 || edad > 65) {
        resultado = "🟠 Riesgo MODERADO\nRequiere control";
        color = Colors.orange;
      } else {
        resultado = "🟢 Riesgo BAJO\nBuen control";
        color = Colors.green;
      }
    });
  }

  Widget campo(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Evaluación de riesgo"),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              campo("Glucosa (mg/dL)", glucosaController),
              const SizedBox(height: 15),

              campo("Presión arterial (sistólica)", presionController),
              const SizedBox(height: 15),

              campo("Edad", edadController),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: evaluar,
                  child: const Text("Evaluar riesgo"),
                ),
              ),

              const SizedBox(height: 30),

              if (resultado.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    resultado,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
