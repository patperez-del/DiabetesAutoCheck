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
  late Box comidasBox;

  List<Map<String, dynamic>> alimentosUsuario = [];
  List<Map<String, dynamic>> comidas = [];

  String busqueda = "";
  String categoria = "Todas";

  final List<String> ingestas = [
    "Desayuno",
    "Almuerzo",
    "Colación / Snack",
    "Té / Once",
    "Cena / Comida",
  ];

  final List<String> categorias = [
    "Todas",
    "Fruta",
    "Verdura",
    "Cereal",
    "Pan",
    "Legumbre",
    "Proteína",
    "Lácteo",
    "Grasa saludable",
    "Bebida",
    "Dulce",
    "Comida chilena",
    "Comida rápida",
  ];

  @override
  void initState() {
    super.initState();
    alimentosUsuarioBox = Hive.box('alimentosUsuarioBox');
    comidasBox = Hive.box('comidasBox');

    alimentosUsuario = alimentosUsuarioBox.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    comidas = comidasBox.keys.map((key) {
      final map = Map<String, dynamic>.from(comidasBox.get(key));
      map["_key"] = key;
      return map;
    }).toList();
  }

  Color colorIG(double ig) {
    if (ig < 55) return Colors.green;
    if (ig < 70) return Colors.orange;
    return Colors.red;
  }

  String textoIG(double ig) {
    if (ig < 55) return "Bajo";
    if (ig < 70) return "Medio";
    return "Alto";
  }

  Color colorResumen(double carb, double igPromedio) {
    if (carb <= 45 && igPromedio < 55) return Colors.green;
    if (carb <= 75 && igPromedio < 70) return Colors.orange;
    return Colors.red;
  }

  String textoResumen(double carb, double igPromedio) {
    if (carb <= 45 && igPromedio < 55) return "Bien";
    if (carb <= 75 && igPromedio < 70) return "Cuidado";
    return "Alto impacto";
  }

  List<Map<String, dynamic>> alimentosFiltrados() {
    final todos = [...alimentosBase, ...alimentosUsuario];

    return todos.where((a) {
      final okCategoria = categoria == "Todas" || a["categoria"] == categoria;
      final okBusqueda = a["nombre"]
          .toString()
          .toLowerCase()
          .contains(busqueda.toLowerCase());

      return okCategoria && okBusqueda;
    }).toList();
  }

  Future<void> guardarComida(
      Map<String, dynamic> alimento,
      String ingesta,
      double cantidad,
      ) async {
    final calBase = (alimento["cal"] is num) ? alimento["cal"].toDouble() : 0.0;
    final carbBase = (alimento["carb"] is num) ? alimento["carb"].toDouble() : 0.0;
    final ig = (alimento["ig"] is num) ? alimento["ig"].toDouble() : 0.0;

    final registro = {
      "nombre": alimento["nombre"],
      "categoria": alimento["categoria"],
      "ingesta": ingesta,
      "cantidad": cantidad,
      "cal": calBase * cantidad,
      "carb": carbBase * cantidad,
      "ig": ig,
      "fecha": DateTime.now().toIso8601String(),
    };

    final key = await comidasBox.add(registro);
    registro["_key"] = key;

    setState(() {
      comidas.add(registro);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${alimento["nombre"]} guardado en $ingesta")),
    );
  }




  void borrarComida(dynamic key) {
    comidasBox.delete(key);

    setState(() {
      comidas.removeWhere((c) => c["_key"] == key);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Alimento eliminado de la ingesta")),
    );
  }
  void abrirRegistroComida(Map<String, dynamic> alimento) {
    String ingestaSeleccionada = "Desayuno";
    final cantidadCtrl = TextEditingController(text: "1");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final cantidad = double.tryParse(cantidadCtrl.text) ?? 1;
            final cal = ((alimento["cal"] is num) ? alimento["cal"].toDouble() : 0.0) * cantidad;
            final carb = ((alimento["carb"] is num) ? alimento["carb"].toDouble() : 0.0) * cantidad;
            final ig = (alimento["ig"] is num) ? alimento["ig"].toDouble() : 0.0;

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alimento["nombre"],
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: ingestaSeleccionada,
                      decoration: const InputDecoration(labelText: "Ingesta"),
                      items: ingestas
                          .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                          .toList(),
                      onChanged: (v) {
                        setModalState(() {
                          ingestaSeleccionada = v!;
                        });
                      },
                    ),

                    TextField(
                      controller: cantidadCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Cantidad / porciones",
                        helperText: "Ejemplo: 1, 0.5, 2",
                      ),
                      onChanged: (_) => setModalState(() {}),
                    ),

                    const SizedBox(height: 12),

                    Text("Calorías: ${cal.toStringAsFixed(0)} kcal"),
                    Text("Carbohidratos: ${carb.toStringAsFixed(1)} g"),
                    Text("Índice glicémico: ${ig.toStringAsFixed(0)} (${textoIG(ig)})"),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text("Guardar alimento"),
                        onPressed: () async {
                          await guardarComida(
                            alimento,
                            ingestaSeleccionada,
                            cantidad,
                          );

                          Navigator.pop(context);
                        },
                      ),
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
                    const Text("Agregar alimento", style: TextStyle(fontSize: 20)),
                    TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: "Nombre")),
                    TextField(controller: calCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Calorías")),
                    TextField(controller: carbCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Carbohidratos")),
                    TextField(controller: igCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Índice glicémico")),

                    DropdownButtonFormField<String>(
                      value: categoriaNueva,
                      items: categorias
                          .where((c) => c != "Todas")
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
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

  List<Map<String, dynamic>> comidasPorIngesta(String ingesta) {
    return comidas.where((c) => c["ingesta"] == ingesta).toList();
  }

  Widget resumenIngesta(String ingesta) {
    final lista = comidasPorIngesta(ingesta);

    final totalCal = lista.fold<double>(
      0,
          (s, e) => s + ((e["cal"] is num) ? e["cal"].toDouble() : 0),
    );

    final totalCarb = lista.fold<double>(
      0,
          (s, e) => s + ((e["carb"] is num) ? e["carb"].toDouble() : 0),
    );

    final totalIg = lista.fold<double>(
      0,
          (s, e) =>
      s +
          (((e["ig"] is num) ? e["ig"].toDouble() : 0) *
              ((e["cantidad"] is num) ? e["cantidad"].toDouble() : 1)),
    );

    final color = colorResumen(totalCarb, totalIg);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: ExpansionTile(
        title: Text(
          ingesta,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Cal: ${totalCal.toStringAsFixed(0)} | Carb: ${totalCarb.toStringAsFixed(1)} g | Impacto IG: ${totalIg.toStringAsFixed(0)}",
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            textoResumen(totalCarb, totalIg),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        children: lista.isEmpty
            ? [const Padding(padding: EdgeInsets.all(12), child: Text("Sin alimentos registrados"))]
            : lista.map((c) {
          return ListTile(
            title: Text(c["nombre"].toString()),
            subtitle: Text(
              "Cantidad: ${c["cantidad"]} | Cal: ${(c["cal"] as num).toStringAsFixed(0)} | Carb: ${(c["carb"] as num).toStringAsFixed(1)} g | IG: ${c["ig"]}",
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                borrarComida(c["_key"]);
              },
            ),
          );
        }).toList(),
      ),
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
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              "Resumen por ingesta",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          SizedBox(
            height: 210,
            child: ListView(
              children: ingestas.map(resumenIngesta).toList(),
            ),
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Buscar alimento",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) {
                setState(() {
                  busqueda = v;
                });
              },
            ),
          ),

          DropdownButton<String>(
            value: categoria,
            items: categorias
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
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
                    onTap: () => abrirRegistroComida(a),
                    title: Text(
                      a["nombre"],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Cal: ${a["cal"]} | Carb: ${a["carb"]} g | Tocar para registrar",
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: colorIG(ig),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        textoIG(ig),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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