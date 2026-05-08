import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'alimentos_data.dart';

class AlimentacionPage extends StatefulWidget {
  const AlimentacionPage({super.key});

  @override
  State<AlimentacionPage> createState() => _AlimentacionPageState();
}

class _AlimentacionPageState extends State<AlimentacionPage> {
  late Box alimentosUsuarioBox;

  List<Map<String, dynamic>> alimentosUsuario = [];

  String busqueda = "";
  String categoria = "Todas";

  // 🔴🟡🟢 COLOR SEGÚN IG
  Color colorIG(double ig) {
    if (ig < 55) return Colors.green;
    if (ig < 70) return Colors.orange;
    return Colors.red;
  }

  // TEXTO SEGÚN IG
  String textoIG(double ig) {
    if (ig < 55) return "Bajo";
    if (ig < 70) return "Medio";
    return "Alto";
  }

  final List<String> categorias = [
    "Todas",
    "Dulce",
    "Lácteo",
    "Cereal",
    "Verdura",
    "Fruta",
    "Bebida",
    "Proteína",
    "Grasa saludable",
  ];

  @override
  void initState() {
    super.initState();

    alimentosUsuarioBox = Hive.box('alimentosUsuarioBox');

    alimentosUsuario = alimentosUsuarioBox.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  List<Map<String, dynamic>> alimentosFiltrados() {
    final todos = [...alimentosBase, ...alimentosUsuario];

    return todos.where((a) {
      final okCategoria =
          categoria == "Todas" || a["categoria"] == categoria;

      final okBusqueda = a["nombre"]
          .toString()
          .toLowerCase()
          .contains(busqueda.toLowerCase());

      return okCategoria && okBusqueda;
    }).toList();
  }

  void abrirFormularioAlimento() {
    final nombreCtrl = TextEditingController();
    final calCtrl = TextEditingController();
    final carbCtrl = TextEditingController();
    final igCtrl = TextEditingController();

    String categoriaNueva = "Dulce";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                top: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      "Agregar alimento",
                      style: TextStyle(fontSize: 20),
                    ),

                    TextField(
                      controller: nombreCtrl,
                      decoration:
                      const InputDecoration(labelText: "Nombre"),
                    ),

                    TextField(
                      controller: calCtrl,
                      keyboardType: TextInputType.number,
                      decoration:
                      const InputDecoration(labelText: "Calorías"),
                    ),

                    TextField(
                      controller: carbCtrl,
                      keyboardType: TextInputType.number,
                      decoration:
                      const InputDecoration(labelText: "Carbohidratos"),
                    ),

                    TextField(
                      controller: igCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: "Índice glicémico"),
                    ),

                    DropdownButtonFormField<String>(
                      value: categoriaNueva,
                      items: categorias
                          .where((c) => c != "Todas")
                          .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c),
                      ))
                          .toList(),
                      onChanged: (v) {
                        setModalState(() {
                          categoriaNueva = v!;
                        });
                      },
                    ),

                    ElevatedButton(
                      child: const Text("Guardar"),
                      onPressed: () {
                        final nuevo = {
                          "nombre": nombreCtrl.text,
                          "categoria": categoriaNueva,
                          "cal": double.tryParse(calCtrl.text) ?? 0,
                          "carb": double.tryParse(carbCtrl.text) ?? 0,
                          "ig": double.tryParse(igCtrl.text) ?? 0,
                        };

                        alimentosUsuarioBox.add(nuevo);

                        setState(() {
                          alimentosUsuario.add(nuevo);
                        });

                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lista = alimentosFiltrados();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Alimentación Pro"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: abrirFormularioAlimento,
          ),
        ],
      ),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: "Buscar alimento",
            ),
            onChanged: (v) {
              setState(() {
                busqueda = v;
              });
            },
          ),

          DropdownButton<String>(
            value: categoria,
            items: categorias
                .map((c) => DropdownMenuItem(
              value: c,
              child: Text(c),
            ))
                .toList(),
            onChanged: (v) {
              setState(() {
                categoria = v!;
              });
            },
          ),

          Expanded(
            child: ListView.builder(
              itemCount: lista.length,
              itemBuilder: (_, i) {
                final a = lista[i];

                final ig = (a["ig"] is num ? a["ig"] : 0).toDouble();

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text(
                      a["nombre"],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Text(
                      "Cal: ${a["cal"]} | Carb: ${a["carb"]}",
                    ),

                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: colorIG(ig),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        textoIG(ig),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}