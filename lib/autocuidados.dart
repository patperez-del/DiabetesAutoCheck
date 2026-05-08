import 'package:flutter/material.dart';

class AutocuidadosPage extends StatelessWidget {
  const AutocuidadosPage({Key? key}) : super(key: key);

  final List<AutocuidadosItem> items = const [
    AutocuidadosItem(
      titulo: 'Control de glucosa',
      texto: 'Registra tus glicemias y observa tus cambios durante el día.',
      detalle:
      'Mide tu glucosa según indicación médica. Registra valores en ayunas, preprandiales y postprandiales. Observa patrones y consulta si hay cifras repetidamente altas o bajas.',
      icono: Icons.monitor_heart,
    ),
    AutocuidadosItem(
      titulo: 'Alimentación saludable',
      texto: 'Prefiere comidas equilibradas y controla los carbohidratos.',
      detalle:
      'Prioriza verduras, proteínas magras, legumbres, frutas enteras y cereales integrales. Evita azúcares simples y controla porciones de pan, arroz, papas, fideos y bebidas azucaradas.',
      icono: Icons.restaurant,
    ),
    AutocuidadosItem(
      titulo: 'Actividad física',
      texto: 'Realiza ejercicio según tu condición y recomendación médica.',
      detalle:
      'Caminar, bailar, nadar o hacer bicicleta ayuda al control glicémico. Idealmente realiza actividad física regular y evita largos periodos sentado.',
      icono: Icons.directions_walk,
    ),
    AutocuidadosItem(
      titulo: 'Hidratación',
      texto: 'Mantén una adecuada ingesta de agua durante el día.',
      detalle:
      'Prefiere agua. Evita bebidas azucaradas y jugos. Una hidratación adecuada ayuda al bienestar general y al control metabólico.',
      icono: Icons.water_drop,
    ),
    AutocuidadosItem(
      titulo: 'Sueño y descanso',
      texto: 'Dormir bien ayuda al control metabólico y bienestar general.',
      detalle:
      'Dormir mal puede alterar el apetito, la glucosa y el ánimo. Mantén horarios regulares, evita pantallas antes de dormir y consulta si hay insomnio persistente.',
      icono: Icons.bedtime,
    ),
    AutocuidadosItem(
      titulo: 'Medicamentos',
      texto: 'Toma tus medicamentos en la dosis y horario indicado.',
      detalle:
      'Registra nombre, dosis y horario de cada medicamento. No suspendas tratamientos sin indicación médica. Usa recordatorios para evitar olvidos.',
      icono: Icons.medication,
    ),
    AutocuidadosItem(
      titulo: 'Cuidado de pies',
      texto: 'Revisa y cuida tus pies todos los días.',
      detalle:
      "🦶 Rutina diaria:\n"
          "• Revisar pies todos los días\n"
          "• Buscar cortes, ampollas o enrojecimiento\n"
          "• Lavar con agua tibia, no caliente\n"
          "• Secar bien entre los dedos\n"
          "• Hidratar, pero no entre los dedos\n"
          "• Cortar uñas rectas y limar bordes\n\n"
          "⚠️ Señales de alerta:\n"
          "• Heridas que no cicatrizan en 2–3 días\n"
          "• Cambios de color: rojo, azul o pálido\n"
          "• Hinchazón persistente\n"
          "• Callos o durezas que crecen\n"
          "• Hormigueo o pérdida de sensibilidad\n\n"
          "👟 Calzado adecuado:\n"
          "• Zapatos cómodos que no aprieten\n"
          "• Revisar el interior antes de usarlos\n"
          "• Calcetines de algodón sin costuras\n"
          "• Nunca caminar descalzo\n\n"
          "🏥 Control:\n"
          "• Podólogo cada 6 meses o ante cualquier cambio.",
      icono: Icons.directions_walk,
    ),
    AutocuidadosItem(
      titulo: 'Cuidado de piel',
      texto: 'Mantén tu piel hidratada y protegida.',
      detalle:
      "💧 Rutina:\n"
          "• Duchas cortas con agua tibia\n"
          "• Usar crema después del baño\n"
          "• Tomar agua durante el día\n\n"
          "☀️ Protección solar:\n"
          "• Usar protector solar FPS 30+\n"
          "• Evitar sol fuerte\n"
          "• Usar sombrero o ropa protectora\n\n"
          "⚠️ Problemas:\n"
          "• Piel seca o agrietada\n"
          "• Picazón persistente\n"
          "• Infecciones\n"
          "• Heridas que no sanan\n\n"
          "✔ Consejo:\n"
          "• Mantener la glucosa controlada ayuda a cuidar la piel.",
      icono: Icons.spa,
    ),
    AutocuidadosItem(
      titulo: 'Salud visual',
      texto: 'Cuida tu visión con controles periódicos.',
      detalle:
      "👁️ Prevención:\n"
          "• Mantén la glucosa controlada\n"
          "• Controla la presión arterial\n"
          "• Evita fumar\n"
          "• Usa lentes de sol al aire libre\n\n"
          "⚠️ Señales de alerta:\n"
          "• Visión borrosa o doble\n"
          "• Manchas o puntos flotantes\n"
          "• Dificultad para ver de noche\n"
          "• Pérdida de visión lateral\n"
          "• Cambios frecuentes en graduación\n\n"
          "🏥 Control:\n"
          "• Fondo de ojo anual obligatorio.",
      icono: Icons.visibility,
    ),
    AutocuidadosItem(
      titulo: 'Salud bucal',
      texto: 'Mantén una buena higiene oral diaria.',
      detalle:
      "🦷 Rutina diaria:\n"
          "• Cepillado 3 veces al día\n"
          "• Uso de hilo dental diariamente\n"
          "• Enjuague bucal sin alcohol\n\n"
          "⚠️ Señales de alerta:\n"
          "• Encías rojas, inflamadas o sangrantes\n"
          "• Mal aliento persistente\n"
          "• Dientes flojos\n"
          "• Dolor al masticar\n"
          "• Úlceras que no sanan\n\n"
          "🏥 Control:\n"
          "• Visita al dentista cada 6 meses e informa que tienes diabetes.",
      icono: Icons.sentiment_satisfied_alt,
    ),
    AutocuidadosItem(
      titulo: 'Mindfulness',
      texto: 'Reduce el estrés con técnicas simples.',
      detalle:
      "🧘 Respiración consciente:\n"
          "• Siéntate cómodamente\n"
          "• Inhala profundo\n"
          "• Exhala lentamente\n"
          "• Repite varias veces\n\n"
          "🧠 Escaneo corporal:\n"
          "• Relaja pies, piernas, abdomen, brazos, cuello y cabeza\n\n"
          "🎯 Atención plena:\n"
          "• Observa lo que ves, escuchas y sientes en este momento\n\n"
          "✔ Objetivo:\n"
          "• Reducir ansiedad y mejorar el control de la glucosa.",
      icono: Icons.self_improvement,
    ),
    AutocuidadosItem(
      titulo: 'Manejo del estrés',
      texto: 'El estrés puede afectar tu glucosa.',
      detalle:
      "😌 El estrés puede elevar la glucosa.\n\n"
          "💨 Técnica 4-7-8:\n"
          "• Inhala 4 segundos\n"
          "• Retén 7 segundos\n"
          "• Exhala 8 segundos\n\n"
          "💪 Relajación muscular:\n"
          "• Tensa y relaja distintas partes del cuerpo\n\n"
          "🧠 Escritura terapéutica:\n"
          "• Escribe lo que sientes\n"
          "• Anota qué te estresa\n"
          "• Escribe posibles soluciones\n\n"
          "✔ Consejos:\n"
          "• Duerme bien\n"
          "• Haz ejercicio\n"
          "• Habla con familia o amigos\n"
          "• Busca ayuda profesional si lo necesitas.",
      icono: Icons.psychology,
    ),
  ];

  void abrirDetalle(BuildContext context, AutocuidadosItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalleAutocuidadosPage(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FB),
      appBar: AppBar(
        title: const Text('Autocuidados'),
        backgroundColor: Colors.pink,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(item.icono, size: 34, color: Colors.pink),
              title: Text(
                item.titulo,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(item.texto),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () => abrirDetalle(context, item),
            ),
          );
        },
      ),
    );
  }
}

class DetalleAutocuidadosPage extends StatelessWidget {
  final AutocuidadosItem item;

  const DetalleAutocuidadosPage({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FB),
      appBar: AppBar(
        title: Text(item.titulo),
        backgroundColor: Colors.pink,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(item.icono, size: 48, color: Colors.pink),
                  const SizedBox(height: 12),
                  Text(
                    item.titulo,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    item.detalle,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AutocuidadosItem {
  final String titulo;
  final String texto;
  final String detalle;
  final IconData icono;

  const AutocuidadosItem({
    required this.titulo,
    required this.texto,
    required this.detalle,
    required this.icono,
  });
}