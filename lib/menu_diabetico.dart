
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'alimentos_data.dart';

class MenuDiabeticoPage extends StatefulWidget {
  const MenuDiabeticoPage({super.key});

  @override
  State<MenuDiabeticoPage> createState() => _MenuDiabeticoPageState();
}

class _MenuDiabeticoPageState extends State<MenuDiabeticoPage> {
  String busqueda = "";
  String categoria = "Todas";

  final List<Map<String, dynamic>> seleccionados = [];

  final List<String> categorias = [
    "Todas",
    "Fruta",
    "Verdura",
    "Cereal",
    "Legumbre",
    "Proteína",
    "Lácteo",
    "Pan",
    "Grasa saludable",
    "Bebida",
    "Dulce",
    "Comida chilena",
    "Comida rápida",
  ];

  final List<Map<String, String>> menuNormal = const [
    {
      "dia": "Día 1",
      "desayuno": "Yogur natural + avena + manzana",
      "almuerzo": "Pollo + ensalada + quinoa",
      "cena": "Tortilla de espinaca + pepino"
    },
    {
      "dia": "Día 2",
      "desayuno": "Pan integral + palta",
      "almuerzo": "Pescado + ensalada + arroz integral",
      "cena": "Ensalada de pollo + tomate"
    },
    {
      "dia": "Día 3",
      "desayuno": "Yogur natural + frutillas",
      "almuerzo": "Lentejas con verduras",
      "cena": "Atún + ensalada verde"
    },
    {
      "dia": "Día 4",
      "desayuno": "Pan integral + huevo",
      "almuerzo": "Carne magra + ensalada",
      "cena": "Sopa de verduras"
    },
    {
      "dia": "Día 5",
      "desayuno": "Avena + yogur",
      "almuerzo": "Pollo + ensalada chilena + quinoa",
      "cena": "Tortilla de verduras"
    },
    {
      "dia": "Día 6",
      "desayuno": "Pan integral + queso fresco",
      "almuerzo": "Pescado + ensalada + arroz integral",
      "cena": "Ensalada de pollo"
    },
    {
      "dia": "Día 7",
      "desayuno": "Yogur + frambuesas",
      "almuerzo": "Garbanzos con verduras",
      "cena": "Ensalada de atún"
    },
  ];

  final List<Map<String, String>> menuEconomico = const [
    {
      "dia": "Día 1",
      "desayuno": "Pan integral + palta",
      "almuerzo": "Lentejas",
      "cena": "Ensalada de repollo"
    },
    {
      "dia": "Día 2",
      "desayuno": "Avena",
      "almuerzo": "Porotos",
      "cena": "Huevo + tomate"
    },
    {
      "dia": "Día 3",
      "desayuno": "Pan integral",
      "almuerzo": "Garbanzos",
      "cena": "Ensalada de zanahoria"
    },
    {
      "dia": "Día 4",
      "desayuno": "Yogur natural",
      "almuerzo": "Pollo + ensalada",
      "cena": "Tortilla de verduras"
    },
    {
      "dia": "Día 5",
      "desayuno": "Avena",
      "almuerzo": "Lentejas",
      "cena": "Atún + ensalada"
    },
    {
      "dia": "Día 6",
      "desayuno": "Pan integral",
      "almuerzo": "Porotos",
      "cena": "Huevo + tomate"
    },
    {
      "dia": "Día 7",
      "desayuno": "Avena",
      "almuerzo": "Garbanzos",
      "cena": "Ensalada de repollo"
    },
  ];

  List<Map<String, dynamic>> alimentosFiltrados() {
    return alimentosBase.where((a) {
      final okCategoria = categoria == "Todas" || a["categoria"] == categoria;
      final okBusqueda = a["nombre"]
          .toString()
          .toLowerCase()
          .contains(busqueda.toLowerCase());

      return okCategoria && okBusqueda;
    }).toList();
  }

  int totalCalorias() {
    return seleccionados.fold<int>(
      0,
          (sum, x) => sum + (x["cal"] as num).round(),
    );
  }

  int totalCarbohidratos() {
    return seleccionados.fold<int>(
      0,
          (sum, x) => sum + (x["carb"] as num).round(),
    );
  }

  double totalCargaGlicemica() {
    return seleccionados.fold<double>(
      0.0,
          (sum, x) {
        final ig = (x["ig"] as num).toDouble();
        final carb = (x["carb"] as num).toDouble();
        return sum + ((ig * carb) / 100);
      },
    );
  }

  String alertaMenu() {
    final carb = totalCarbohidratos();
    final carga = totalCargaGlicemica();

    if (seleccionados.isEmpty) {
      return "Elige alimentos para armar tu menú.";
    }

    if (carb <= 45 && carga < 20) {
      return "🟢 Menú equilibrado en carbohidratos.";
    }

    if (carb <= 60 && carga < 35) {
      return "🟡 Menú moderado. Cuida porciones y acompaña con proteínas o verduras.";
    }

    return "🔴 Menú alto en carbohidratos o carga glicémica. Conviene reducir pan, arroz, papas, jugos o dulces.";
  }

  Color colorAlerta() {
    final carb = totalCarbohidratos();
    final carga = totalCargaGlicemica();

    if (seleccionados.isEmpty) return Colors.grey;
    if (carb <= 45 && carga < 20) return Colors.green;
    if (carb <= 60 && carga < 35) return Colors.orange;
    return Colors.red;
  }

  Widget listaMenu(String titulo, List<Map<String, String>> menu) {
    return ExpansionTile(
      initiallyExpanded: false,
      title: Text(
        titulo,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      children: menu.map((dia) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dia["dia"]!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("Desayuno: ${dia["desayuno"]}"),
                Text("Almuerzo: ${dia["almuerzo"]}"),
                Text("Cena: ${dia["cena"]}"),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget resumenMenuArmado() {
    return Card(
      margin: const EdgeInsets.all(12),
      color: colorAlerta().withOpacity(0.12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Arma tu menú",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Alimentos elegidos: ${seleccionados.length}"),
            Text("Calorías: ${totalCalorias()} kcal"),
            Text("Hidratos de carbono: ${totalCarbohidratos()} g"),
            Text("Carga glicémica: ${totalCargaGlicemica().toStringAsFixed(1)}"),
            const SizedBox(height: 8),
            Text(
              alertaMenu(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorAlerta(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget filtros() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: "Buscar alimento",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                busqueda = value;
              });
            },
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: categoria,
            decoration: const InputDecoration(
              labelText: "Categoría",
              border: OutlineInputBorder(),
            ),
            items: categorias.map((c) {
              return DropdownMenuItem(value: c, child: Text(c));
            }).toList(),
            onChanged: (value) {
              setState(() {
                categoria = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget listaAlimentosParaMenu() {
    final lista = alimentosFiltrados();

    if (busqueda.trim().isEmpty && categoria == "Todas") {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Text(
              "Busca un alimento o elige una categoría para agregarlo a tu menú.",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Column(
      children: lista.map((a) {
        final ig = a["ig"];
        final carb = a["carb"];
        final cal = a["cal"];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: ListTile(
            title: Text(
              a["nombre"],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("$cal kcal | $carb g HC | IG $ig"),
            trailing: IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.green),
              onPressed: () {
                setState(() {
                  seleccionados.add(Map<String, dynamic>.from(a));
                });
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget alimentosSeleccionados() {
    if (seleccionados.isEmpty) {
      return const SizedBox();
    }

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            "Alimentos seleccionados",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...seleccionados.asMap().entries.map((entry) {
          final index = entry.key;
          final a = entry.value;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: ListTile(
              title: Text(a["nombre"]),
              subtitle: Text(
                "${a["cal"]} kcal | ${a["carb"]} g HC | IG ${a["ig"]}",
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    seleccionados.removeAt(index);
                  });
                },
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  void limpiarMenu() {
    setState(() {
      seleccionados.clear();
    });
  }

  void guardarMenu() async {
    if (seleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Primero elige alimentos para tu menú.")),
      );
      return;
    }

    final box = Hive.box('menusBox');
    final ahora = DateTime.now();

    final menuGuardado = {
      "fecha": ahora.toString(),
      "calorias": totalCalorias(),
      "carbohidratos": totalCarbohidratos(),
      "carga": totalCargaGlicemica(),
      "items": seleccionados.map((e) => e["nombre"]).toList(),
    };

    await box.add(menuGuardado);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Menú guardado correctamente")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menús y planificación"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: guardarMenu,
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: limpiarMenu,
          ),
        ],
      ),
      body: ListView(
        children: [
          listaMenu("MENÚ NORMAL (7 días)", menuNormal),
          listaMenu("MENÚ ECONÓMICO (7 días)", menuEconomico),
          const Divider(height: 30),
          resumenMenuArmado(),
          filtros(),
          listaAlimentosParaMenu(),
          alimentosSeleccionados(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}