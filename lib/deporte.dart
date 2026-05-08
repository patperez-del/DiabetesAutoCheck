import 'package:flutter/material.dart';

class DeportePage extends StatefulWidget {
  const DeportePage({super.key});

  @override
  State<DeportePage> createState() => _DeportePageState();
}

class _DeportePageState extends State<DeportePage> {

  String deporteSeleccionado = "Caminata leve";
  int minutos = 30;

  List<Map<String,dynamic>> historial = [];

  final Map<String,int> deportes = {

    "Caminata leve": 180,
    "Caminata moderada": 250,
    "Trote": 500,
    "Baile": 300,
    "Tenis": 450,
    "Natación": 500,
    "Tai Chi": 200,
    "Yoga": 180,
    "Bicicleta": 400,
    "Golf": 280,
    "Ski": 420

  };

  int calcularCalorias(String deporte,int minutos){

    int kcalHora = deportes[deporte] ?? 200;

    double kcalMin = kcalHora / 60;

    return (kcalMin * minutos).round();

  }

  void registrarActividad(){

    int calorias = calcularCalorias(deporteSeleccionado,minutos);

    DateTime hoy = DateTime.now();

    setState(() {

      historial.add({

        "deporte": deporteSeleccionado,
        "minutos": minutos,
        "calorias": calorias,
        "fecha": hoy

      });

    });

  }

  int caloriasHoy(){

    DateTime hoy = DateTime.now();

    int total = 0;

    for(var act in historial){

      DateTime fecha = act["fecha"];

      if(fecha.day==hoy.day &&
          fecha.month==hoy.month &&
          fecha.year==hoy.year){

        total += act["calorias"] as int;

      }

    }

    return total;

  }

  int caloriasSemana(){

    DateTime hoy = DateTime.now();

    int total = 0;

    for(var act in historial){

      DateTime fecha = act["fecha"];

      if(hoy.difference(fecha).inDays <= 7){

        total += act["calorias"] as int;

      }

    }

    return total;

  }

  int caloriasMes(){

    DateTime hoy = DateTime.now();

    int total = 0;

    for(var act in historial){

      DateTime fecha = act["fecha"];

      if(fecha.month == hoy.month &&
          fecha.year == hoy.year){

        total += act["calorias"] as int;

      }

    }

    return total;

  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar: AppBar(
        title: const Text("Actividad Física"),
      ),

      body: ListView(

        padding: const EdgeInsets.all(16),

        children: [

          const Text(
            "Selecciona deporte",
            style: TextStyle(fontSize:18,fontWeight:FontWeight.bold),
          ),

          DropdownButton<String>(

            value: deporteSeleccionado,

            items: deportes.keys.map((dep){

              return DropdownMenuItem(

                value: dep,
                child: Text(dep),

              );

            }).toList(),

            onChanged: (value){

              setState(() {

                deporteSeleccionado = value!;

              });

            },

          ),

          const SizedBox(height:20),

          const Text(
            "Minutos de actividad",
            style: TextStyle(fontSize:18,fontWeight:FontWeight.bold),
          ),

          Slider(

            value: minutos.toDouble(),

            min: 10,
            max: 120,

            divisions: 11,

            label: "$minutos min",

            onChanged: (value){

              setState(() {

                minutos = value.round();

              });

            },

          ),

          Center(
            child: Text(
              "$minutos minutos",
              style: const TextStyle(fontSize:22),
            ),
          ),

          const SizedBox(height:20),

          ElevatedButton(

            onPressed: registrarActividad,

            child: const Text("Registrar actividad"),

          ),

          const SizedBox(height:30),

          const Text(
            "Resumen",
            style: TextStyle(fontSize:22,fontWeight:FontWeight.bold),
          ),

          const SizedBox(height:10),

          Text("🔥 Calorías hoy: ${caloriasHoy()} kcal"),
          Text("📅 Calorías semana: ${caloriasSemana()} kcal"),
          Text("🗓️ Calorías mes: ${caloriasMes()} kcal"),

          const SizedBox(height:30),

          const Text(
            "Historial",
            style: TextStyle(fontSize:22,fontWeight:FontWeight.bold),
          ),

          const SizedBox(height:10),

          ...historial.map((act){

            return Card(

              child: ListTile(

                title: Text(act["deporte"]),

                subtitle: Text("${act["minutos"]} min"),

                trailing: Text("${act["calorias"]} kcal"),

              ),

            );

          })

        ],

      ),

    );

  }

}
