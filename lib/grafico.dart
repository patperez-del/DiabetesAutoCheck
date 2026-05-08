import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';



class GraficoGlucosaPage extends StatelessWidget {
  const GraficoGlucosaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Glucosa vs comidas"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(show: true),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 90),
                  FlSpot(1, 110),
                  FlSpot(2, 130),
                  FlSpot(3, 120),
                  FlSpot(4, 150),
                ],
                isCurved: true,
                colors: [Colors.blue],
                barWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}