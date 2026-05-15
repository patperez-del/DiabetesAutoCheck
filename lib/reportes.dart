import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'alimentacion.dart';
import 'agua.dart';
import 'medicamentos.dart';
import 'glucosapro.dart';

class ReportesPage extends StatelessWidget {
  const ReportesPage({Key? key}) : super(key: key);

  String hoy() {
    final now = DateTime.now();

    return "${now.year.toString().padLeft(4, '0')}-"
        "${now.month.toString().padLeft(2, '0')}-"
        "${now.day.toString().padLeft(2, '0')}";
  }

  List<Map<String, dynamic>> registrosDeHoy(Box box) {
    return box.values
        .where((item) {
      try {
        final map = Map<String, dynamic>.from(item);

        return map["fecha"]
            .toString()
            .startsWith(hoy());
      } catch (_) {
        return false;
      }
    })
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
  Map<String, List<Map<String, dynamic>>> agruparPorDia(
      List<Map<String, dynamic>> registros,
      ) {
    final Map<String, List<Map<String, dynamic>>> grupos = {};

    for (final item in registros) {
      final fecha = item["fecha"].toString().substring(0, 10);
      grupos.putIfAbsent(fecha, () => []);
      grupos[fecha]!.add(item);
    }

    return grupos;
  }
  int sumarInt(List<Map<String, dynamic>> lista, String campo) {
    return lista.fold<int>(
      0,
          (sum, item) =>
      sum + ((item[campo] ?? 0) as num).round(),
    );
  }

  double sumarDouble(
      List<Map<String, dynamic>> lista,
      String campo,
      ) {
    return lista.fold<double>(
      0.0,
          (sum, item) =>
      sum + ((item[campo] ?? 0) as num).toDouble(),
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
    if (carbos > 180 ||
        carga > 100 ||
        vasos < 4 ||
        horas < 5 ||
        pendientes > 0) {
      return "🔴 Atención: hoy hay factores que conviene revisar.";
    }

    if (carbos > 130 ||
        carga > 70 ||
        vasos < 6 ||
        horas < 6) {
      return "🟡 Día moderado: vas bien, pero hay aspectos por mejorar.";
    }

    if (comidas == 0) {
      return "⚪ Sin suficientes datos de alimentación todavía.";
    }

    return "🟢 Buen día de autocuidado.";
  }

  Widget tarjeta(
      String titulo,
      String valor,
      String detalle,
      IconData icono,
      Color color,
      ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icono,
              color: color,
              size: 34,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  detalle,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Text(
            valor,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget graficoBarra(
      String titulo,
      double valor,
      double meta,
      Color color,
      ) {
    final porcentaje = meta == 0
        ? 0.0
        : (valor / meta).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          ClipRRect(
            borderRadius:
            BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: porcentaje,
              minHeight: 16,
              backgroundColor: Colors.white,
              valueColor:
              AlwaysStoppedAnimation<Color>(
                color,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "${valor.toStringAsFixed(0)} / ${meta.toStringAsFixed(0)}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final comidasBox = Hive.box('comidasBox');
    final aguaBox = Hive.box('hidratacionBox');
    final suenoBox = Hive.box('suenoBox');
    final medicamentosBox =
    Hive.box('medicamentosBox');
    final menusBox = Hive.box('menusBox');
    final ejercicioBox = Hive.box('ejercicioBox');

    final comidasHoy =
    registrosDeHoy(comidasBox);

    final calorias =
    sumarInt(comidasHoy, "cal");

    final carbos =
    sumarInt(comidasHoy, "carb");

    final carga = comidasHoy.fold<double>(
      0,
          (sum, item) {
        final ig =
        ((item["ig"] ?? 0) as num)
            .toDouble();

        final cantidad =
        ((item["cantidad"] ?? 1) as num)
            .toDouble();

        return sum + (ig * cantidad);
      },
    );

    final vasos =
    aguaBox.get('vasos', defaultValue: 0)
    as int;

    final metaAgua =
    aguaBox.get('meta', defaultValue: 8)
    as int;

    final horasRaw =
    suenoBox.get('horas',
        defaultValue: 0.0);

    final horas =
    (horasRaw as num).toDouble();

    final calidad = suenoBox
        .get('calidad',
        defaultValue: "Sin dato")
        .toString();

    final medicamentos =
    medicamentosBox.values
        .map(
          (x) =>
      Map<String, dynamic>.from(x),
    )
        .toList();

    final tomados = medicamentos
        .where((m) => m["tomado"] == true)
        .length;

    final pendientes = medicamentos
        .where((m) => m["tomado"] != true)
        .length;

    final ultimoMenu = menusBox.isEmpty
        ? null
        : Map<String, dynamic>.from(
      menusBox.getAt(
        menusBox.length - 1,
      ),
    );
    final ejerciciosHoy = ejercicioBox.values
        .where((item) {
      try {
        final map = Map<String, dynamic>.from(item);

        return map["fecha"]
            .toString()
            .startsWith(hoy());
      } catch (_) {
        return false;
      }
    })
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    final minutosEjercicio = ejerciciosHoy.fold<int>(
      0,
          (sum, item) =>
      sum + ((item["minutos"] ?? 0) as num).round(),
    );

    final caloriasEjercicio = ejerciciosHoy.fold<int>(
      0,
          (sum, item) =>
      sum + ((item["calorias"] ?? 0) as num).round(),
    );
    final estado = estadoGeneral(
      comidas: comidasHoy.length,
      carbos: carbos,
      carga: carga,
      vasos: vasos,
      horas: horas,
      pendientes: pendientes,
    );

    return Scaffold(
      backgroundColor:
      const Color(0xFFF5F6FA),

      appBar: AppBar(
        title: const Text("Mi resumen"),
        backgroundColor: Colors.blue,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [
            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.all(20),

              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade400,
                    Colors.indigo.shade400,
                  ],
                ),

                borderRadius:
                BorderRadius.circular(24),

                boxShadow: [
                  BoxShadow(
                    color: Colors.blue
                        .withOpacity(0.25),
                    blurRadius: 14,
                    offset:
                    const Offset(0, 8),
                  ),
                ],
              ),

              child: Text(
                estado,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight:
                  FontWeight.bold,
                  height: 1.4,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 12),

            tarjeta(
              "Alimentación",
              "$carbos g",
              "Hoy: ${comidasHoy.length} alimentos | "
                  "Calorías: $calorias kcal | "
                  "Impacto IG: ${carga.toStringAsFixed(1)}",
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
              "Calidad: $calidad",
              Icons.bedtime,
              Colors.indigo,
            ),
            tarjeta(
              "Actividad física",
              "$minutosEjercicio min",
              "Ejercicios: ${ejerciciosHoy.length} | "
                  "Calorías: $caloriasEjercicio kcal",
              Icons.directions_run,
              Colors.deepOrange,
            ),
            tarjeta(
              "Medicamentos",
              "$tomados/${medicamentos.length}",
              "Tomados: $tomados | "
                  "Pendientes: $pendientes",
              Icons.medication,
              Colors.pink,
            ),

            if (ultimoMenu != null)
              tarjeta(
                "Último menú armado",
                "${ultimoMenu["carbohidratos"] ?? 0} g",
                "Calorías: "
                    "${ultimoMenu["calorias"] ?? 0}",
                Icons.menu_book,
                Colors.teal,
              ),

            const SizedBox(height: 18),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(18),
              ),

              child: Padding(
                padding:
                const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    const Text(
                      "Accesos rápidos",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                        height: 14),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,

                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                const AlimentacionPage(),
                              ),
                            );
                          },

                          icon: const Icon(
                              Icons.restaurant),

                          label: const Text(
                              "Alimentación"),
                        ),

                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                const AguaPage(),
                              ),
                            );
                          },

                          icon: const Icon(
                              Icons.water_drop),

                          label:
                          const Text("Agua"),
                        ),

                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                const MedicamentosPage(),
                              ),
                            );
                          },

                          icon: const Icon(
                              Icons.medication),

                          label: const Text(
                              "Medicamentos"),
                        ),

                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                const GlucosaPage(),
                              ),
                            );
                          },

                          icon: const Icon(
                              Icons.monitor_heart),

                          label: const Text(
                              "Glucosa"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              "Gráficos del día",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            graficoBarra(
              "Carbohidratos",
              carbos.toDouble(),
              180,
              Colors.green,
            ),

            graficoBarra(
              "Agua",
              vasos.toDouble(),
              metaAgua.toDouble(),
              Colors.blue,
            ),

            graficoBarra(
              "Medicamentos tomados",
              tomados.toDouble(),
              medicamentos.isEmpty
                  ? 1
                  : medicamentos.length
                  .toDouble(),
              Colors.pink,
            ),

            graficoBarra(
              "Impacto glicémico",
              carga,
              120,
              Colors.orange,
            ),
            graficoBarra(
              "Actividad física",
              minutosEjercicio.toDouble(),
              60,
              Colors.deepOrange,
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 18),

            const Text(
              "Historial de alimentación",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            ...agruparPorDia(
              comidasBox.values
                  .map((x) => Map<String, dynamic>.from(x))
                  .toList(),
            ).entries.map((entry) {
              final totalCal = sumarInt(entry.value, "cal");
              final totalCarb = sumarInt(entry.value, "carb");

              return tarjeta(
                entry.key,
                "$totalCarb g",
                "Alimentos: ${entry.value.length} | Calorías: $totalCal kcal",
                Icons.history,
                Colors.brown,
              );
            }).toList(),
            const Text(
              "Interpretación",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Card(
              child: Padding(
                padding:
                const EdgeInsets.all(14),

                child: Text(
                  "Este resumen ayuda a ver "
                      "relaciones entre alimentación, "
                      "hidratación, sueño y medicamentos.",
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}