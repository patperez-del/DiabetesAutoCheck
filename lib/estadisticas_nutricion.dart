import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class EstadisticasNutricionPage extends StatelessWidget {

  final List<Map<String,dynamic>> comidas;

  const EstadisticasNutricionPage({Key? key, required this.comidas}) : super(key: key);

  Map<String,int> caloriasPorComida(){

    Map<String,int> data = {
      "Desayuno":0,
      "Almuerzo":0,
      "Cena":0,
      "Snack":0
    };

    for(var comida in comidas){

      String tipo = comida["tipo"];
      int cal = comida["cal"];

      data[tipo] = data[tipo]! + cal;

    }

    return data;
  }

  @override
  Widget build(BuildContext context) {

    final calorias = caloriasPorComida();

    return Scaffold(

      appBar: AppBar(
        title: const Text("Estadísticas Nutricionales"),
      ),

      body: Center(

        child: SizedBox(
          height:250,
          child: PieChart(
            PieChartData(
              sections: [

                PieChartSectionData(
                    value: calorias["Desayuno"]!.toDouble(),
                    color: Colors.orange,
                    title: "Des"
                ),

                PieChartSectionData(
                    value: calorias["Almuerzo"]!.toDouble(),
                    color: Colors.blue,
                    title: "Alm"
                ),

                PieChartSectionData(
                    value: calorias["Cena"]!.toDouble(),
                    color: Colors.purple,
                    title: "Cena"
                ),

                PieChartSectionData(
                    value: calorias["Snack"]!.toDouble(),
                    color: Colors.green,
                    title: "Snack"
                ),

              ],
            ),
          ),
        ),

      ),

    );

  }

}