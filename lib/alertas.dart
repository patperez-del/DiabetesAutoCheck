import 'package:flutter/material.dart';

class AlertasPage extends StatefulWidget {
  const AlertasPage({Key? key}) : super(key: key);

  @override
  _AlertasPageState createState() => _AlertasPageState();
}

class _AlertasPageState extends State<AlertasPage> {
  final List<AlertaItem> alertas = [];

  final TextEditingController tituloController = TextEditingController();
  final TextEditingController horaController = TextEditingController();

  String tipoSeleccionado = 'Medicación';

  void agregarAlerta() {
    if (tituloController.text.isEmpty || horaController.text.isEmpty) {
      return;
    }

    setState(() {
      alertas.add(
        AlertaItem(
          titulo: tituloController.text,
          tipo: tipoSeleccionado,
          hora: horaController.text,
          activa: true,
        ),
      );
    });

    tituloController.clear();
    horaController.clear();
  }

  void cambiarEstado(int index) {
    setState(() {
      alertas[index].activa = !alertas[index].activa;
    });
  }

  void eliminarAlerta(int index) {
    setState(() {
      alertas.removeAt(index);
    });
  }

  IconData iconoPorTipo(String tipo) {
    if (tipo == 'Medicación') {
      return Icons.medication;
    } else if (tipo == 'Glucosa') {
      return Icons.monitor_heart;
    } else {
      return Icons.directions_walk;
    }
  }

  Color colorPorTipo(String tipo) {
    if (tipo == 'Medicación') {
      return Colors.pink;
    } else if (tipo == 'Glucosa') {
      return Colors.purple;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alertas y Notificaciones'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: tipoSeleccionado,
              decoration: const InputDecoration(
                labelText: 'Tipo de recordatorio',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Medicación',
                  child: Text('Medicación'),
                ),
                DropdownMenuItem(
                  value: 'Glucosa',
                  child: Text('Monitoreo de glucosa'),
                ),
                DropdownMenuItem(
                  value: 'Actividad física',
                  child: Text('Actividad física'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  tipoSeleccionado = value!;
                });
              },
            ),
            const SizedBox(height: 10),

            TextField(
              controller: tituloController,
              decoration: const InputDecoration(
                labelText: 'Nombre del recordatorio',
                hintText: 'Ej: Metformina / Control glicemia / Caminata',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: horaController,
              decoration: const InputDecoration(
                labelText: 'Horario',
                hintText: 'Ej: 08:00 / 14:00 / 20:00',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: agregarAlerta,
              icon: const Icon(Icons.add_alert),
              label: const Text('Agregar alerta'),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: alertas.isEmpty
                  ? const Center(
                child: Text(
                  'Aún no hay alertas registradas.',
                  style: TextStyle(fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: alertas.length,
                itemBuilder: (context, index) {
                  final alerta = alertas[index];

                  return Card(
                    child: ListTile(
                      leading: Icon(
                        iconoPorTipo(alerta.tipo),
                        color: colorPorTipo(alerta.tipo),
                        size: 32,
                      ),
                      title: Text(
                        alerta.titulo,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${alerta.tipo}\nHorario: ${alerta.hora}',
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: alerta.activa,
                            onChanged: (value) {
                              cambiarEstado(index);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => eliminarAlerta(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlertaItem {
  final String titulo;
  final String tipo;
  final String hora;
  bool activa;

  AlertaItem({
    required this.titulo,
    required this.tipo,
    required this.hora,
    required this.activa,
  });
}