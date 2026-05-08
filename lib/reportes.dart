import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ReportesPage extends StatelessWidget {
  const ReportesPage({Key? key}) : super(key: key);

  String hoy() {
    final now = DateTime.now();
    return "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  List<Map<String, dynamic>> registrosDeHoy(Box box) {
    return box.values
        .where((item) {
      try {
        final map = Map<String, dynamic>.from(item);
        return map["fecha"] == hoy();
      } catch (_) {
        return false;
      }
    })
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  int sumarInt(List<Map<String, dynamic>> lista, String campo) {
    return lista.fold<int>(
      0,
          (sum, item) => sum + ((item[campo] ?? 0) as num).round(),
    );
  }

  double sumarDouble(List<Map<String, dynamic>> lista, String campo) {
    return lista.fold<double>(
      0.0,
          (sum, item) => sum + ((item[campo] ?? 0) as num).toDouble(),
    );
  }

  String estadoGeneral({
    required int comidas,
    required int carbos,
    required double carga,
    required int vasos,
    required double horas,
    required int pendientes,
  }) {
    if (carbos > 180 || carga > 100 || vasos < 4 || horas < 5 || pendientes > 0) {
      return "🔴 Atención: hoy hay factores que conviene revisar.";
    }

    if (carbos > 130 || carga > 70 || vasos < 6 || horas < 6) {
      return "🟡 Día moderado: vas bien, pero hay aspectos por mejorar.";
    }

    if (comidas == 0) {
      return "⚪ Sin suficientes datos de alimentación todavía.";
    }

    return "🟢 Buen día de autocuidado.";
  }

  Widget tarjeta(String titulo, String valor, String detalle, IconData icono, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 7),
      child: ListTile(
        leading: Icon(icono, color: color, size: 34),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        subtitle: Text(detalle),
        trailing: Text(
          valor,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final comidasBox = Hive.box('comidasBox');
    final aguaBox = Hive.box('hidratacionBox');
    final suenoBox = Hive.box('suenoBox');
    final medicamentosBox = Hive.box('medicamentosBox');
    final menusBox = Hive.box('menusBox');

    final comidasHoy = registrosDeHoy(comidasBox);
    final calorias = sumarInt(comidasHoy, "cal");
    final carbos = sumarInt(comidasHoy, "carb");
    final carga = sumarDouble(comidasHoy, "carga");

    final vasos = aguaBox.get('vasos', defaultValue: 0) as int;
    final metaAgua = aguaBox.get('meta', defaultValue: 8) as int;

    final horasRaw = suenoBox.get('horas', defaultValue: 0.0);
    final horas = (horasRaw as num).toDouble();
    final calidad = suenoBox.get('calidad', defaultValue: "Sin dato").toString();

    final medicamentos = medicamentosBox.values
        .map((x) => Map<String, dynamic>.from(x))
        .toList();

    final tomados = medicamentos.where((m) => m["tomado"] == true).length;
    final pendientes = medicamentos.where((m) => m["tomado"] != true).length;

    final ultimoMenu = menusBox.isEmpty
        ? null
        : Map<String, dynamic>.from(menusBox.getAt(menusBox.length - 1));

    final estado = estadoGeneral(
      comidas: comidasHoy.length,
      carbos: carbos,
      carga: carga,
      vasos: vasos,
      horas: horas,
      pendientes: pendientes,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi resumen"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  estado,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    height: 1.35,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            tarjeta(
              "Alimentación",
              "$carbos g",
              "Hoy: ${comidasHoy.length} alimentos | $calorias kcal | carga ${carga.toStringAsFixed(1)}",
              Icons.restaurant,
              Colors.green,
            ),

            tarjeta(
              "Agua",
              "$vasos/$metaAgua",
              "Vasos registrados hoy.",
              Icons.water_drop,
              Colors.blue,
            ),

            tarjeta(
              "Sueño",
              "${horas.toStringAsFixed(0)} h",
              "Calidad: $calidad. Dormir mal puede subir glucosa y apetito.",
              Icons.bedtime,
              Colors.indigo,
            ),

            tarjeta(
              "Medicamentos",
              "$tomados/${
                  medicamentos.length
              }",
              "Tomados: $tomados | Pendientes: $pendientes",
              Icons.medication,
              Colors.pink,
            ),

            if (ultimoMenu != null)
              tarjeta(
                "Último menú armado",
                "${ultimoMenu["carbohidratos"] ?? 0} g",
                "Calorías: ${ultimoMenu["calorias"] ?? 0} | Carga glicémica: ${((ultimoMenu["carga"] ?? 0) as num).toStringAsFixed(1)}",
                Icons.menu_book,
                Colors.teal,
              ),

            const SizedBox(height: 14),

            const Text(
              "Interpretación",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Text(
                  "Este resumen ayuda a ver relaciones entre alimentación, hidratación, sueño y medicamentos. "
                      "No reemplaza el control médico, pero puede servir para conversar mejor con tu equipo de salud.",
                  style: const TextStyle(fontSize: 16, height: 1.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}