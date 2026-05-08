import 'package:flutter/material.dart';
import 'peso.dart';
import 'presion.dart';
import 'riesgo.dart';

class AutochequeoPage extends StatelessWidget {
  const AutochequeoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Autochequeo metabólico"),
        backgroundColor: Colors.green,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PesoPage(),
                  ),
                );
              },
              child: const Text("Peso"),
            ),

            const SizedBox(height:20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PresionPage(),
                  ),
                );
              },
              child: const Text("Presión arterial"),
            ),

            const SizedBox(height:20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RiesgoPage(),
                  ),
                );
              },
              child: const Text("Riesgo cardiovascular"),
            ),

          ],
        ),
      ),
    );
  }
}