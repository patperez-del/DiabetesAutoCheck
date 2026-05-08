import 'package:flutter/material.dart';

class MiniCursoPage extends StatelessWidget {
  const MiniCursoPage({Key? key}) : super(key: key);

  final List<CursoItem> cursos = const [
    CursoItem(
      titulo: '1. Qué es la diabetes',
      descripcion: 'Conceptos básicos para entender la enfermedad.',
      contenido:
      'La diabetes es una condición crónica en la que el cuerpo no logra regular adecuadamente la glucosa en la sangre. Puede deberse a falta de insulina, resistencia a la insulina o ambas. El autocuidado diario es clave para prevenir complicaciones.',
      pregunta: '¿La diabetes requiere autocuidado diario?',
      respuesta: 'Sí. El control diario ayuda a prevenir complicaciones.',
      icono: Icons.info,
    ),
    CursoItem(
      titulo: '2. Glucosa: ayuno, pre y postprandial',
      descripcion: 'Cuándo y por qué medir la glucosa.',
      contenido:
      'La glucosa en ayunas se mide antes de comer. La preprandial se mide antes de una comida. La postprandial se mide normalmente 1 a 2 horas después de comer. Estos registros ayudan a entender cómo responde el cuerpo a alimentos, medicamentos y actividad física.',
      pregunta: '¿La glucosa postprandial se mide después de comer?',
      respuesta: 'Correcto. Se mide después de la ingesta.',
      icono: Icons.monitor_heart,
    ),
    CursoItem(
      titulo: '3. Alimentación y carbohidratos',
      descripcion: 'Relación entre comida, porciones y glucosa.',
      contenido:
      'Los carbohidratos son el nutriente que más influye en la glucosa. Están presentes en pan, arroz, papas, fideos, frutas, legumbres, leche y alimentos azucarados. Controlar porciones permite mejorar el control glicémico.',
      pregunta: '¿Los carbohidratos influyen directamente en la glucosa?',
      respuesta: 'Sí. Son el principal nutriente que eleva la glucosa.',
      icono: Icons.restaurant,
    ),
    CursoItem(
      titulo: '4. Índice glicémico',
      descripcion: 'Alimentos que suben la glucosa rápido o lento.',
      contenido:
      'El índice glicémico indica la velocidad con que un alimento puede elevar la glucosa. Alimentos de alto índice glicémico suben rápido la glucosa. Los de bajo índice glicémico producen una elevación más lenta y sostenida.',
      pregunta: '¿Un alimento de alto índice glicémico sube rápido la glucosa?',
      respuesta: 'Sí. Por eso conviene moderar su consumo.',
      icono: Icons.show_chart,
    ),
    CursoItem(
      titulo: '5. Ejercicio aeróbico vs anaeróbico',
      descripcion: 'Diferencias entre caminar, correr, pesas e intensidad.',
      contenido:
      'El ejercicio aeróbico, como caminar, nadar o bicicleta, suele bajar la glucosa progresivamente y mejora la sensibilidad a la insulina. El ejercicio anaeróbico, como pesas o sprints, puede subir la glucosa temporalmente por adrenalina, pero mejora la masa muscular y el metabolismo a largo plazo. Caminar 10 a 20 minutos después de comer puede ayudar a disminuir alzas postprandiales. En la noche se debe tener cuidado si existe riesgo de hipoglicemia, especialmente si la persona usa insulina.',
      pregunta: '¿Caminar después de comer puede ayudar a controlar la glucosa?',
      respuesta: 'Sí. Puede disminuir las alzas de glucosa post comida.',
      icono: Icons.fitness_center,
    ),
    CursoItem(
      titulo: '6. Medicamentos y adherencia',
      descripcion: 'Importancia de cumplir dosis y horarios.',
      contenido:
      'Tomar los medicamentos según indicación médica ayuda a mantener la glucosa más estable. Saltarse dosis o cambiar horarios sin supervisión puede afectar el control metabólico. Los recordatorios ayudan a mejorar la adherencia.',
      pregunta: '¿Es recomendable suspender medicamentos sin indicación médica?',
      respuesta: 'No. Siempre debe consultarse con un profesional.',
      icono: Icons.medication,
    ),
    CursoItem(
      titulo: '7. Hipoglicemia e hiperglicemia',
      descripcion: 'Reconocer señales de glucosa baja o alta.',
      contenido:
      'La hipoglicemia es glucosa baja y puede causar sudoración, temblor, hambre, confusión o debilidad. La hiperglicemia es glucosa alta y puede causar sed, cansancio, visión borrosa y aumento de orina. Registrar síntomas y valores ayuda a actuar a tiempo.',
      pregunta: '¿Temblor y sudoración pueden ser signos de hipoglicemia?',
      respuesta: 'Sí. Son señales frecuentes de glucosa baja.',
      icono: Icons.warning,
    ),
    CursoItem(
      titulo: '8. Cuándo consultar al médico',
      descripcion: 'Signos de alarma y control profesional.',
      contenido:
      'Se debe consultar si hay glucosas repetidamente altas o bajas, síntomas intensos, pérdida de conciencia, dolor torácico, dificultad respiratoria, infecciones, heridas que no cicatrizan o dudas sobre medicamentos. La app apoya, pero no reemplaza al profesional de salud.',
      pregunta: '¿La app reemplaza al médico?',
      respuesta: 'No. La app es una herramienta de apoyo.',
      icono: Icons.medical_services,
    ),
    CursoItem(
      titulo: '9. Prevención de complicaciones',
      descripcion: 'Cuidado cardiovascular, renal, visual y de pies.',
      contenido:
      'El buen control de glucosa, presión arterial, alimentación, actividad física y medicamentos ayuda a prevenir complicaciones cardiovasculares, renales, visuales y neurológicas. También es importante revisar pies, piel y realizar controles médicos periódicos.',
      pregunta: '¿El control de glucosa ayuda a prevenir complicaciones?',
      respuesta: 'Sí. Es una parte central de la prevención.',
      icono: Icons.health_and_safety,
    ),
    CursoItem(
      titulo: '10. Autocuidado diario',
      descripcion: 'Rutina simple para vivir mejor con diabetes.',
      contenido:
      'Una rutina de autocuidado incluye medir glucosa según indicación, tomar medicamentos, alimentarse bien, moverse durante el día, dormir adecuadamente, hidratarse y registrar cambios. Pequeñas acciones diarias generan grandes beneficios.',
      pregunta: '¿Pequeñas acciones diarias pueden mejorar el control?',
      respuesta: 'Sí. La constancia es fundamental.',
      icono: Icons.favorite,
    ),
  ];

  void abrirCurso(BuildContext context, CursoItem curso) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalleCursoPage(curso: curso),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Mini Curso Interactivo'),
        backgroundColor: Colors.pink,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: cursos.length,
        itemBuilder: (context, index) {
          final curso = cursos[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(curso.icono, size: 34, color: Colors.pink),
              title: Text(
                curso.titulo,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              subtitle: Text(curso.descripcion),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () => abrirCurso(context, curso),
            ),
          );
        },
      ),
    );
  }
}

class DetalleCursoPage extends StatefulWidget {
  final CursoItem curso;

  const DetalleCursoPage({
    Key? key,
    required this.curso,
  }) : super(key: key);

  @override
  _DetalleCursoPageState createState() => _DetalleCursoPageState();
}

class _DetalleCursoPageState extends State<DetalleCursoPage> {
  bool mostrarRespuesta = false;
  bool completado = false;

  void verRespuesta() {
    setState(() {
      mostrarRespuesta = true;
    });
  }

  void marcarCompletado() {
    setState(() {
      completado = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lección marcada como completada.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final curso = widget.curso;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lección'),
        backgroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(curso.icono, size: 50, color: Colors.pink),
                    const SizedBox(height: 16),
                    Text(
                      curso.titulo,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      curso.contenido,
                      style: const TextStyle(
                        fontSize: 17,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: const Color(0xFFFFF3F8),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pregunta rápida',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      curso.pregunta,
                      style: const TextStyle(fontSize: 17),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: verRespuesta,
                      child: const Text('Ver respuesta'),
                    ),
                    if (mostrarRespuesta) ...[
                      const SizedBox(height: 12),
                      Text(
                        curso.respuesta,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: marcarCompletado,
              icon: Icon(
                completado ? Icons.check_circle : Icons.radio_button_unchecked,
              ),
              label: Text(
                completado ? 'Lección completada' : 'Marcar como completada',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CursoItem {
  final String titulo;
  final String descripcion;
  final String contenido;
  final String pregunta;
  final String respuesta;
  final IconData icono;

  const CursoItem({
    required this.titulo,
    required this.descripcion,
    required this.contenido,
    required this.pregunta,
    required this.respuesta,
    required this.icono,
  });
}