import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class EjercicioPage extends StatefulWidget {
  const EjercicioPage({super.key});

  @override
  State<EjercicioPage> createState() => _EjercicioPageState();
}

class _EjercicioPageState extends State<EjercicioPage> {
  late Box ejercicioBox;

  String tipo = "Caminata";
  String intensidad = "Moderada";
  double minutos = 30;

  final TextEditingController notaController = TextEditingController();

  final List<String> tipos = [
    "Caminata",
    "Bicicleta",
    "Trote",
    "Baile",
    "Natación",
    "Gimnasio",
    "Yoga",
    "Pilates",
    "Elíptica",
    "Ejercicios en casa",
    "Otro",
  ];

  final List<String> intensidades = [
    "Suave",
    "Moderada",
    "Alta",
  ];

  @override
  void initState() {
    super.initState();
    ejercicioBox = Hive.box('ejercicioBox');
  }

  String fechaHoy() => DateFormat('yyyy-MM-dd').format(DateTime.now());
  String horaActual() => DateFormat('HH:mm').format(DateTime.now());

  List<Map<String, dynamic>> registrosHoy() {
    return ejercicioBox.values
        .where((item) => item["fecha"] == fechaHoy())
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  int factorCalorico() {
    if (intensidad == "Suave") return 4;
    if (intensidad == "Moderada") return 6;
    return 9;
  }

  int caloriasEstimadas() {
    return (minutos * factorCalorico()).round();
  }

  int minutosTotalesHoy() {
    return registrosHoy().fold(0, (total, item) {
      return total + (item["minutos"] as num).round();
    });
  }

  int caloriasTotalesHoy() {
    return registrosHoy().fold(0, (total, item) {
      return total + (item["calorias"] as num).round();
    });
  }

  String consejoEjercicio() {
    final min = minutosTotalesHoy();

    if (min == 0) {
      return "Registra actividad física para evaluar tu día.";
    }

    if (min < 20) {
      return "Buen comienzo. Intenta completar al menos 30 minutos de actividad.";
    }

    if (min < 45) {
      return "Muy bien. La actividad física ayuda al control glicémico.";
    }

    return "Excelente actividad hoy. Mantén hidratación y controla tu recuperación.";
  }

  Future<void> guardarEjercicio() async {
    final registro = {
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
      "fecha": fechaHoy(),
      "hora": horaActual(),
      "tipo": tipo,
      "intensidad": intensidad,
      "minutos": minutos.round(),
      "calorias": caloriasEstimadas(),
      "nota": notaController.text,
    };

    await ejercicioBox.add(registro);
    notaController.clear();

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Ejercicio guardado correctamente")),
    );
  }

  Future<void> eliminarRegistro(String id) async {
    dynamic keyEncontrada;

    for (final key in ejercicioBox.keys) {
      final item = ejercicioBox.get(key);
      if (item["id"] == id) {
        keyEncontrada = key;
        break;
      }
    }

    if (keyEncontrada != null) {
      await ejercicioBox.delete(keyEncontrada);
      setState(() {});
    }
  }

  Future<void> limpiarDia() async {
    final keys = ejercicioBox.keys.where((k) {
      final item = ejercicioBox.get(k);
      return item["fecha"] == fechaHoy();
    }).toList();

    for (final key in keys) {
      await ejercicioBox.delete(key);
    }

    setState(() {});
  }

  void confirmarLimpiarDia() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Borrar ejercicios de hoy"),
        content: const Text("¿Quieres borrar todos los ejercicios registrados hoy?"),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Borrar"),
            onPressed: () {
              Navigator.pop(context);
              limpiarDia();
            },
          ),
        ],
      ),
    );
  }

  void verHistorial() {
    final registros = ejercicioBox.values
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    registros.sort((a, b) {
      final fa = "${a["fecha"]} ${a["hora"]}";
      final fb = "${b["fecha"]} ${b["hora"]}";
      return fb.compareTo(fa);
    });

    showModalBottomSheet(
      context: context,
      builder: (_) {
        if (registros.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Text("No hay historial de ejercicio."),
          );
        }

        return ListView.builder(
          itemCount: registros.length,
          itemBuilder: (context, index) {
            final item = registros[index];

            return ListTile(
              leading: const Icon(Icons.directions_walk, color: Colors.orange),
              title: Text("${item["fecha"]} ${item["hora"]} - ${item["tipo"]}"),
              subtitle: Text(
                "${item["minutos"]} min | ${item["intensidad"]} | ${item["calorias"]} kcal",
              ),
            );
          },
        );
      },
    );
  }

  Widget resumenHoy() {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Resumen de actividad de hoy",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Ejercicios registrados: ${registrosHoy().length}"),
            Text("Minutos totales: ${minutosTotalesHoy()} min"),
            Text("Calorías estimadas: ${caloriasTotalesHoy()} kcal"),
            const SizedBox(height: 8),
            Text(
              consejoEjercicio(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget formulario() {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: tipo,
              decoration: const InputDecoration(
                labelText: "Tipo de ejercicio",
                border: OutlineInputBorder(),
              ),
              items: tipos.map((t) {
                return DropdownMenuItem(value: t, child: Text(t));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  tipo = value!;
                });
              },
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: intensidad,
              decoration: const InputDecoration(
                labelText: "Intensidad",
                border: OutlineInputBorder(),
              ),
              items: intensidades.map((i) {
                return DropdownMenuItem(value: i, child: Text(i));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  intensidad = value!;
                });
              },
            ),

            const SizedBox(height: 12),

            Text(
              "Duración: ${minutos.round()} minutos",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            Slider(
              min: 5,
              max: 180,
              divisions: 35,
              value: minutos,
              onChanged: (value) {
                setState(() {
                  minutos = value;
                });
              },
            ),

            Text(
              "Calorías estimadas: ${caloriasEstimadas()} kcal",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: notaController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Nota opcional",
                hintText: "Ej: caminé después de almuerzo, me sentí bien...",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: guardarEjercicio,
                icon: const Icon(Icons.save),
                label: const Text("Guardar ejercicio"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listaHoy() {
    final hoy = registrosHoy();

    if (hoy.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text("Aún no hay ejercicios registrados hoy."),
      );
    }

    return Column(
      children: hoy.map((item) {
        final nota = item["nota"] == null || item["nota"].toString().isEmpty
            ? ""
            : "\nNota: ${item["nota"]}";

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: ListTile(
            leading: const Icon(Icons.fitness_center, color: Colors.orange),
            title: Text("${item["hora"]} - ${item["tipo"]}"),
            subtitle: Text(
              "${item["minutos"]} min | ${item["intensidad"]} | ${item["calorias"]} kcal$nota",
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => eliminarRegistro(item["id"]),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ejercicio Pro"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(icon: const Icon(Icons.history), onPressed: verHistorial),
          IconButton(icon: const Icon(Icons.delete_sweep), onPressed: confirmarLimpiarDia),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            resumenHoy(),
            formulario(),
            const Divider(height: 28),
            listaHoy(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}