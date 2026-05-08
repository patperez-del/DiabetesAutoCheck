import 'package:flutter/material.dart';

class ComunidadPage extends StatelessWidget {
  const ComunidadPage({Key? key}) : super(key: key);

  final List<ComunidadItem> items = const [
    ComunidadItem(
      titulo: 'Preguntas frecuentes',
      descripcion: 'Respuestas simples sobre uso de la app, glucosa, alimentación y autocuidado.',
      icono: Icons.help_outline,
    ),
    ComunidadItem(
      titulo: 'Soporte técnico',
      descripcion: 'Ayuda para resolver problemas de uso, registro de datos o configuración.',
      icono: Icons.support_agent,
    ),
    ComunidadItem(
      titulo: 'Comunidad GlucoCheck',
      descripcion: 'Espacio de apoyo, educación y acompañamiento entre usuarios.',
      icono: Icons.groups,
    ),
    ComunidadItem(
      titulo: 'Contactar a un profesional',
      descripcion: 'Canal para orientación o derivación según necesidad del usuario.',
      icono: Icons.medical_services,
    ),
    ComunidadItem(
      titulo: 'Emergencias',
      descripcion: 'Indicaciones básicas para saber cuándo consultar de forma urgente.',
      icono: Icons.warning,
    ),
  ];

  void abrirDetalle(BuildContext context, ComunidadItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalleComunidadPage(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunidad y Soporte'),
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
                  fontSize: 17,
                ),
              ),
              subtitle: Text(item.descripcion),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () => abrirDetalle(context, item),
            ),
          );
        },
      ),
    );
  }
}

class DetalleComunidadPage extends StatelessWidget {
  final ComunidadItem item;

  const DetalleComunidadPage({
    Key? key,
    required this.item,
  }) : super(key: key);

  String contenido() {
    if (item.titulo == 'Preguntas frecuentes') {
      return 'Aquí se incluirán respuestas a dudas frecuentes sobre el uso de GlucoCheck, registro de glucosa, alimentación, medicamentos y reportes.';
    }

    if (item.titulo == 'Soporte técnico') {
      return 'Este espacio permitirá solicitar ayuda si el usuario tiene problemas con la app, ingreso de datos, sincronización o funcionamiento general.';
    }

    if (item.titulo == 'Comunidad GlucoCheck') {
      return 'Espacio pensado para acompañamiento, educación y apoyo entre usuarios, con contenidos seguros y moderados.';
    }

    if (item.titulo == 'Contactar a un profesional') {
      return 'Permitirá orientar al usuario para contactar a un profesional de salud o preparar información útil para su control médico.';
    }

    if (item.titulo == 'Emergencias') {
      return 'Si presentas síntomas graves, hipoglicemia severa, pérdida de conciencia, dolor torácico o dificultad respiratoria, busca atención médica urgente.';
    }

    return item.descripcion;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.titulo),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(item.icono, size: 48, color: Colors.pink),
                const SizedBox(height: 20),
                Text(
                  item.titulo,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  contenido(),
                  style: const TextStyle(
                    fontSize: 17,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ComunidadItem {
  final String titulo;
  final String descripcion;
  final IconData icono;

  const ComunidadItem({
    required this.titulo,
    required this.descripcion,
    required this.icono,
  });
}