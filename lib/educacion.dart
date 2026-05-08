import 'package:flutter/material.dart';

class EducacionPage extends StatelessWidget {
  const EducacionPage({super.key});

  final List<Map<String,String>> temas = const [

    {
      "titulo":"¿Qué es la diabetes?",
      "texto":"La diabetes es una enfermedad metabólica donde el cuerpo no usa correctamente la glucosa."
    },

    {
      "titulo":"Hipoglicemia",
      "texto":"La glucosa baja de 70 mg/dL puede causar sudoración, temblores, hambre intensa y mareos."
    },

    {
      "titulo":"Hiperglicemia",
      "texto":"La glucosa elevada provoca sed, cansancio, visión borrosa y micción frecuente."
    },

    {
      "titulo":"Síntomas de alerta",
      "texto":"Sed excesiva, orinar frecuentemente, cansancio, visión borrosa o pérdida de peso."
    },

    {
      "titulo":"Hidratación",
      "texto":"Beber 6-8 vasos de agua al día ayuda a controlar la glucosa y prevenir deshidratación."
    },

    {
      "titulo":"Cuidado de pies",
      "texto":"Revisar los pies diariamente para detectar heridas o cambios de color."
    },

    {
      "titulo":"Salud bucal",
      "texto":"Cepillarse al menos dos veces al día y usar hilo dental para prevenir infecciones."
    },

    {
      "titulo":"Actividad física",
      "texto":"El ejercicio mejora el control de la glucosa y la salud cardiovascular."
    },

    {
      "titulo":"Alimentación",
      "texto":"Preferir alimentos con bajo índice glucémico como verduras y proteínas magras."
    },

    {
      "titulo":"Control del estrés",
      "texto":"El estrés aumenta la glucosa. Practicar respiración profunda o mindfulness."
    }

  ];

  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar: AppBar(
        title: const Text("Educación Diabetes"),
      ),

      body: ListView.builder(

        itemCount: temas.length,

        itemBuilder:(context,index){

          final tema = temas[index];

          return Card(

            margin: const EdgeInsets.all(10),

            child: ListTile(

              title: Text(
                tema["titulo"]!,
                style: const TextStyle(
                    fontSize:18,
                    fontWeight:FontWeight.bold
                ),
              ),

              trailing: const Icon(Icons.arrow_forward_ios),

              onTap:(){

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder:(context)=>DetalleTemaPage(

                      titulo: tema["titulo"]!,
                      texto: tema["texto"]!,

                    ),

                  ),

                );

              },

            ),

          );

        },

      ),

    );

  }

}

class DetalleTemaPage extends StatelessWidget {

  final String titulo;
  final String texto;

  const DetalleTemaPage({
    super.key,
    required this.titulo,
    required this.texto
  });

  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar: AppBar(
        title: Text(titulo),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Text(
          texto,
          style: const TextStyle(
              fontSize:18
          ),
        ),

      ),

    );

  }

}
