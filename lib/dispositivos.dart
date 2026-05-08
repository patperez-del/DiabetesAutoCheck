import 'package:flutter/material.dart';

class DispositivosPage extends StatefulWidget {
  const DispositivosPage({Key? key}) : super(key: key);

  @override
  _DispositivosPageState createState() => _DispositivosPageState();
}

class _DispositivosPageState extends State<DispositivosPage> {
  final List<DispositivoItem> dispositivos = [
    DispositivoItem(
      nombre: 'Glucómetro Bluetooth',
      tipo: 'Glucómetro',
      estado: 'No conectado',
      icono: Icons.bloodtype,
    ),
    DispositivoItem(
      nombre: 'Reloj inteligente',
      tipo: 'Wearable',
      estado: 'No conectado',
      icono: Icons.watch,
    ),
    DispositivoItem(
      nombre: 'Pulsera de actividad',
      tipo: 'Wearable',
      estado: 'No conectado',
      icono: Icons.directions_walk,
    ),
  ];

  void cambiarEstado(int index) {
    setState(() {
      dispositivos[index].estado =
      dispositivos[index].estado == 'Conectado' ? 'No conectado' : 'Conectado';
    });
  }

  void sincronizar(int index) {
    setState(() {
      dispositivos[index].ultimaSincronizacion = DateTime.now();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Datos sincronizados desde ${dispositivos[index].nombre}'),
      ),
    );
  }

  String textoFecha(DateTime? fecha) {
    if (fecha == null) {
      return 'Sin sincronización';
    }

    return '${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}';
  }

  Color colorEstado(String estado) {
    return estado == 'Conectado' ? Colors.green : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Integración con Dispositivos'),
        backgroundColor: Colors.pink,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dispositivos.length,
        itemBuilder: (context, index) {
          final item = dispositivos[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      item.icono,
                      size: 36,
                      color: colorEstado(item.estado),
                    ),
                    title: Text(
                      item.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    subtitle: Text(
                      '${item.tipo}\nEstado: ${item.estado}\nÚltima sincronización: ${textoFecha(item.ultimaSincronizacion)}',
                    ),
                    isThreeLine: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => cambiarEstado(index),
                        icon: Icon(
                          item.estado == 'Conectado'
                              ? Icons.link_off
                              : Icons.link,
                        ),
                        label: Text(
                          item.estado == 'Conectado'
                              ? 'Desconectar'
                              : 'Conectar',
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: item.estado == 'Conectado'
                            ? () => sincronizar(index)
                            : null,
                        icon: const Icon(Icons.sync),
                        label: const Text('Sincronizar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class DispositivoItem {
  final String nombre;
  final String tipo;
  String estado;
  final IconData icono;
  DateTime? ultimaSincronizacion;

  DispositivoItem({
    required this.nombre,
    required this.tipo,
    required this.estado,
    required this.icono,
    this.ultimaSincronizacion,
  });
}