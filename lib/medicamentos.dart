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

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController dosisController = TextEditingController();
  final TextEditingController horarioController = TextEditingController();
  final TextEditingController notaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    medicamentosBox = Hive.box('medicamentosBox');
  }

  String fechaHoy() => DateFormat('yyyy-MM-dd').format(DateTime.now());
  String horaActual() => DateFormat('HH:mm').format(DateTime.now());

  List<Map<String, dynamic>> medicamentos() {
    return medicamentosBox.values
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
            Text("Registrados: ${medicamentos().length}"),
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
                label: const Text('Agregar medicamento'),
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
            'Aún no hay medicamentos registrados.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return Column(
      children: lista.map((med) {
        final tomado = med["tomado"] == true;

        return Card(
          child: ListTile(
            leading: Icon(
              tomado ? Icons.check_circle : Icons.medication,
              color: tomado ? Colors.green : Colors.pink,
              size: 34,
            ),
            title: Text(
              med["nombre"],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Dosis: ${med["dosis"]}\n'
                  'Horario: ${med["horario"]}\n'
                  'Estado: ${tomado ? "Tomado ${med["horaTomado"]}" : "Pendiente"}\n'
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
            formulario(),
            const SizedBox(height: 14),
            listaMedicamentos(),
          ],
        ),
      ),
    );
  }
}