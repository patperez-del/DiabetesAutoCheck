
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlucosaPage extends StatefulWidget {
  const GlucosaPage({super.key});

  @override
  State<GlucosaPage> createState() => _GlucosaPageState();
}

class _GlucosaPageState extends State<GlucosaPage> {

  final TextEditingController glucosaController = TextEditingController();

  List<Map<String, dynamic>> mediciones = [];
  String tipoMedicion = "Ayunas";
  double promedio = 0;
  String interpretarGlucosa(double valor, String tipo) {
    if (tipo == "Ayunas") {
      if (valor < 70) return "Hipoglucemia en ayunas";
      if (valor < 100) return "Normal en ayunas";
      if (valor < 126) return "Alteración en ayunas";
      return "Posible diabetes (ayunas)";
    } else {
      if (valor < 70) return "Hipoglucemia post comida";
      if (valor < 140) return "Normal post comida";
      if (valor < 180) return "Elevación post comida";
      return "Hiperglucemia post comida";
    }
  }
  String riesgo = "Sin datos";
  double promedioSemanal = 0;
  double maxSemanal = 0;
  double minSemanal = 0;
  Future guardarDatos() async {

    final prefs = await SharedPreferences.getInstance();

    List<String> lista = mediciones.map((e) => "${e["valor"]}|${e["tipo"]}").toList();

    prefs.setStringList("glucosa", lista);
  }

  Future cargarDatos() async {

    final prefs = await SharedPreferences.getInstance();

    List<String>? datos = prefs.getStringList("glucosa");

    if(datos != null){

      setState(() {

        mediciones = datos.map((e) {
          final partes = e.split("|");
          return {
            "valor": double.parse(partes[0]),
            "tipo": partes[1],
          };
        }).toList();

        promedio = mediciones
            .map((e) => e["valor"] as double)
            .reduce((a, b) => a + b) / mediciones.length;
        if (mediciones.length >= 7) {

          List<double> semana = mediciones
              .sublist(mediciones.length - 7)
              .map((e) => e["valor"] as double)
              .toList();

          promedioSemanal = semana.reduce((a, b) => a + b) / semana.length;

          maxSemanal = semana.reduce((a, b) => a > b ? a : b);
          minSemanal = semana.reduce((a, b) => a < b ? a : b);

        }
        if (promedio < 100) {
          riesgo = "🟢 Normal";
        } else if (promedio < 126) {
          riesgo = "🟠 Riesgo metabólico";
        } else {
          riesgo = "🔴 Riesgo diabetes";
        }

      });

    }

  }

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  void guardarGlucosa() {

    if(glucosaController.text.isEmpty) return;

    double valor = double.parse(glucosaController.text);

    if (valor < 70) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠ Hipoglucemia"),
          backgroundColor: Colors.orange,
        ),
      );
    }

    if (valor > 180) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠ Hiperglucemia"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {

      mediciones.add({
        "valor": valor,
        "tipo": tipoMedicion,
      });

      promedio = mediciones
          .map((e) => e["valor"] as double)
          .reduce((a, b) => a + b) / mediciones.length;

      if (promedio < 100) {
        riesgo = "🟢 Normal";
      } else if (promedio < 126) {
        riesgo = "🟠 Riesgo metabólico";
      } else {
        riesgo = "🔴 Riesgo diabetes";
      }

    });

    guardarDatos();

    glucosaController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Guardado correctamente"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Registro de Glucosa"),
        backgroundColor: Colors.blue,
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: glucosaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Ingresar glucosa mg/dL",
                border: OutlineInputBorder(),
              ),
            ),
            DropdownButton<String>(
              value: tipoMedicion,
              isExpanded: true,
              items: ["Ayunas", "Post comida"]
                  .map((tipo) => DropdownMenuItem(
                value: tipo,
                child: Text(tipo),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  tipoMedicion = value!;
                });
              },
            ),

            const SizedBox(height:20),

            ElevatedButton(
              onPressed: guardarGlucosa,
              child: const Text("Guardar medición"),
            ),

            const SizedBox(height:20),

            Text(
              "Promedio: ${promedio.toStringAsFixed(1)}",
              style: const TextStyle(fontSize:20,fontWeight: FontWeight.bold),
            ),

            const SizedBox(height:10),

            Text(
              "Estado metabólico: $riesgo",
              style: const TextStyle(fontSize:18,fontWeight: FontWeight.bold),
            ),

            const SizedBox(height:10),

            Text(
              mediciones.isEmpty
                  ? ""aMin: ${mediciones.map((e) => e["valor"]).reduce((a,b)=>a<b?a:b)}",
              style: const TextStyle(fontSize:16),
            ),

            const SizedBox(height:20),

            SizedBox(
              height:200,
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        mediciones.length,
                            (index) => FlSpot(index.toDouble(), mediciones[index]),
                      ),
                      isCurved: true,
                      colors: [Colors.blue],
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height:20),

            const Text(
              "Historial",
              style: TextStyle(fontSize:18,fontWeight: FontWeight.bold),
            ),

            Expanded(

              child: ListView.builder(

                itemCount: mediciones.length,

                itemBuilder:(context,index){

                  Color color;

                  if (mediciones[index] < 100) {
                    color = Colors.green;
                  } else if (mediciones[index] < 180) {
                    color = Colors.orange;
                  } else {
                    color = Colors.red;
                  }

                  return ListTile(

                    leading: const Icon(Icons.monitor_heart,color:Colors.red),

                    title: Text(
                      "${mediciones[index]["valor"]} mg/dL (${mediciones[index]["tipo"]})"
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  );

                },

              ),

            )

          ],

        ),

      ),

    );

  }

}