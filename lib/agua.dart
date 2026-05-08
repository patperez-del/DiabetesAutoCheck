
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AguaPage extends StatefulWidget {
  const AguaPage({Key? key}) : super(key: key);

  @override
  State<AguaPage> createState() => _AguaPageState();
}

class _AguaPageState extends State<AguaPage> {
  int vasos = 0;
  int meta = 8;

  late Box box;

  @override
  void initState() {
    super.initState();
    box = Hive.box('hidratacionbox');

    vasos = box.get('vasos', defaultValue: 0);
    meta = box.get('meta', defaultValue: 8);
  }

  void agregarVaso() {
    setState(() {
      vasos++;
      box.put('vasos', vasos);
    });
  }

  void quitarVaso() {
    if (vasos > 0) {
      setState(() {
        vasos--;
        box.put('vasos', vasos);
      });
    }
  }

  double get porcentaje {
    if (meta == 0) return 0;
    return vasos / meta;
  }

  String consejo() {
    if (vasos == 0) return "Comienza a hidratarte 💧";
    if (porcentaje < 0.5) return "Aún falta tomar más agua 💧";
    if (porcentaje < 1) return "Vas bien, sigue así 👍";
    return "Excelente hidratación 👏";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hidratación"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "💧 Vasos de agua",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Text(
              "$vasos / $meta",
              style: const TextStyle(fontSize: 40),
            ),

            const SizedBox(height: 10),

            LinearProgressIndicator(
              value: porcentaje.clamp(0, 1),
              minHeight: 10,
            ),

            const SizedBox(height: 16),

            Text(
              consejo(),
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: quitarVaso,
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: agregarVaso,
                  child: const Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 20),

            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Meta diaria (vasos)",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                final n = int.tryParse(value);
                if (n != null && n > 0) {
                  setState(() {
                    meta = n;
                    box.put('meta', meta);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}