import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class MedicamentosPage extends StatefulWidget {
  const MedicamentosPage({Key? key}) : super(key: key);

  @override
  State<MedicamentosPage> createState() => _MedicamentosPageState();
}

class _MedicamentosPageState extends State<MedicamentosPage> {
  late Box medicamentosBox;
  late Box medicamentosFrecuentesBox;

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController dosisController = TextEditingController();
  final TextEditingController horarioController = TextEditingController();
  final TextEditingController notaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    medicamentosBox = Hive.box('medicamentosBox');
    medicamentosFrecuentesBox = Hive.box('medicamentosFrecuentesBox');
  }

  String fechaHoy() => DateFormat('yyyy-MM-dd').format(DateTime.now());
  String horaActual() => DateFormat('HH:mm').format(DateTime.now());

  List<Map<String, dynamic>> medicamentos() {
    return medicamentosBox.values
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  List<Map<String, dynamic>> medicamentosFrecuentes() {
    return medicamentosFrecuentesBox.values
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<void> agregarMedicamento() async {
    if (nombreController.text.isEmpty ||
        dosisController.text.isEmpty ||
        horarioController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa nombre, dosis y horario.")),
      );
      return;
    }

    final registro = {
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
      "nombre": nombreController.text,
      "dosis": dosisController.text,
      "horario": horarioController.text,
      "nota": notaController.text,
      "tomado": false,
      "fecha": fechaHoy(),
      "horaRegistro": horaActual(),
      "horaTomado": "",
    };

    await medicamentosBox.add(registro);

    final existe = medicamentosFrecuentes().any(
          (m) =>
      m["nombre"] == nombreController.text &&
          m["dosis"] == dosisController.text,
    );

    if (!existe) {
      await medicamentosFrecuentesBox.add({
        "nombre": nombreController.text,
        "dosis": dosisController.text,
        "horario": horarioController.text,
      });
    }

    nombreController.clear();
    dosisController.clear();
    horarioController.clear();
    notaController.clear();

    setState(() {});
  }

  Future<void> marcarTomado(String id) async {
    dynamic keyEncontrada;

    for (final key in medicamentosBox.keys) {
      final item = medicamentosBox.get(key);
      if (item["id"] == id) {
        keyEncontrada = key;
        break;
      }
    }

    if (keyEncontrada != null) {
      final item = Map<String, dynamic>.from(medicamentosBox.get(keyEncontrada));
      final nuevoEstado = !(item["tomado"] == true);

      item["tomado"] = nuevoEstado;
      item["horaTomado"] = nuevoEstado ? horaActual() : "";

      await medicamentosBox.put(keyEncontrada, item);
      setState(() {});
    }
  }

  Future<void> eliminarMedicamento(String id) async {
    dynamic keyEncontrada;

    for (final key in medicamentosBox.keys) {
      final item = medicamentosBox.get(key);
      if (item["id"] == id) {
        keyEncontrada = key;
        break;
      }
    }

    if (keyEncontrada != null) {
      await medicamentosBox.delete(keyEncontrada);
      setState(() {});
    }
  }

  Future<void> eliminarFrecuente(Map<String, dynamic> med) async {
    dynamic keyEncontrada;

    for (final key in medicamentosFrecuentesBox.keys) {
      final item = medicamentosFrecuentesBox.get(key);
      if (item["nombre"] == med["nombre"] && item["dosis"] == med["dosis"]) {
        keyEncontrada = key;
        break;
      }
    }

    if (keyEncontrada != null) {
      await medicamentosFrecuentesBox.delete(keyEncontrada);
      setState(() {});
    }
  }
  bool medicamentoAtrasado(Map<String, dynamic> med) {
    if (med["tomado"] == true) return false;

    try {
      final horario = med["horario"].toString().split("-").first.trim();

      final partes = horario.split(":");

      if (partes.length != 2) return false;

      final hora = int.parse(partes[0]);
      final minuto = int.parse(partes[1]);

      final ahora = DateTime.now();

      final horaMed = DateTime(
        ahora.year,
        ahora.month,
        ahora.day,
        hora,
        minuto,
      );

      return ahora.isAfter(horaMed);
    } catch (e) {
      return false;
    }
  }

  int totalPendientes() {
    return medicamentos().where((m) => m["tomado"] != true).length;
  }

  int totalTomados() {
    return medicamentos().where((m) => m["tomado"] == true).length;
  }

  Widget resumen() {
    return Card(
      color: Colors.pink.shade50,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Resumen de medicamentos",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text("Registrados hoy: ${medicamentos().length}"),
            Text("Tomados: ${totalTomados()}"),
            Text("Pendientes: ${totalPendientes()}"),
            const SizedBox(height: 8),
            const Text(
              "Toca un medicamento para marcarlo como tomado o pendiente.",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget medicamentosFrecuentesWidget() {
    final lista = medicamentosFrecuentes();

    if (lista.isEmpty) {
      return const SizedBox();
    }

    return Card(
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Medicamentos habituales",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Toca uno para rellenar nombre, dosis y horario automáticamente.",
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: lista.map((med) {
                return InputChip(
                  label: Text("${med["nombre"]} (${med["dosis"]})"),
                  onPressed: () {
                    nombreController.text = med["nombre"] ?? "";
                    dosisController.text = med["dosis"] ?? "";
                    horarioController.text = med["horario"] ?? "";
                    setState(() {});
                  },
                  onDeleted: () => eliminarFrecuente(med),
                  deleteIcon: const Icon(Icons.close),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget formulario() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre del medicamento',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.medication),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: dosisController,
              decoration: const InputDecoration(
                labelText: 'Dosis',
                hintText: 'Ej: 500 mg / 1 comprimido',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.local_pharmacy),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: horarioController,
              decoration: const InputDecoration(
                labelText: 'Horario',
                hintText: 'Ej: 08:00 - 20:00',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.access_time),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: notaController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Nota opcional',
                hintText: 'Ej: tomar con comida, indicado por médico...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: agregarMedicamento,
                icon: const Icon(Icons.add),
                label: const Text('Registrar medicamento'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listaMedicamentos() {
    final lista = medicamentos();

    if (lista.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Text(
            'Aún no hay medicamentos registrados hoy.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return Column(
      children: lista.map((med) {
        final tomado = med["tomado"] == true;
        final atrasado = medicamentoAtrasado(med);

        return Card(
          child: ListTile(
            leading: Icon(
              tomado ? Icons.check_circle : Icons.medication,
              color: tomado
                  ? Colors.green
                  : atrasado
                  ? Colors.red
                  : Colors.pink,
              size: 34,
            ),
            title: Text(
              med["nombre"] ?? "",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Dosis: ${med["dosis"]}\n'
                  'Horario: ${med["horario"]}\n'
                  'Estado: ${tomado ? "Tomado ${med["horaTomado"]}" : atrasado ? "ATRASADO" : "Pendiente"}\n'
                  '${med["nota"] == "" ? "" : "Nota: ${med["nota"]}"}',
            ),
            isThreeLine: true,
            onTap: () => marcarTomado(med["id"]),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => eliminarMedicamento(med["id"]),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Medicamentos'),
        backgroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            resumen(),
            medicamentosFrecuentesWidget(),
            formulario(),
            const SizedBox(height: 14),
            listaMedicamentos(),
          ],
        ),
      ),
    );
  }
}