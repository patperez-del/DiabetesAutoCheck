import 'package:flutter/material.dart';

class PresionPage extends StatefulWidget {
  const PresionPage({super.key});

  @override
  State<PresionPage> createState() => _PresionPageState();
}

class _PresionPageState extends State<PresionPage> {

  final sistolicaController = TextEditingController();
  final diastolicaController = TextEditingController();

  String estado = "";

  void evaluarPresion(){

    double s = double.parse(sistolicaController.text);
    double d = double.parse(diastolicaController.text);

    setState(() {

      if(s < 120 && d < 80){
        estado = "Normal";
      }
      else if(s < 130 && d < 80){
        estado = "Elevada";
      }
      else if(s < 140 || d < 90){
        estado = "Hipertensión grado 1";
      }
      else{
        estado = "Hipertensión grado 2";
      }

    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Presión arterial"),
        backgroundColor: Colors.red,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: sistolicaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Sistólica",
              ),
            ),

            const SizedBox(height:20),

            TextField(
              controller: diastolicaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Diastólica",
              ),
            ),

            const SizedBox(height:20),

            ElevatedButton(
              onPressed: evaluarPresion,
              child: const Text("Evaluar"),
            ),

            const SizedBox(height:30),

            Text(
              estado,
              style: const TextStyle(
                  fontSize:22,
                  fontWeight: FontWeight.bold
              ),
            )

          ],

        ),

      ),

    );

  }

}