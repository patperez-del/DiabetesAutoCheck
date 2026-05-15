import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

class GlucosaPage extends StatefulWidget {
  const GlucosaPage({Key? key}) : super(key: key);

  @override
  _GlucosaPageState createState() => _GlucosaPageState();
}

class _GlucosaPageState extends State<GlucosaPage> {
  final TextEditingController glucosaController = TextEditingController();
  final TextEditingController carbohidratosController = TextEditingController();
  final TextEditingController observacionController = TextEditingController();

  List<RegistroGlucosa> mediciones = [];

  String tipoMedicion = 'Ayunas';
  String comidaAsociada = 'Sin comida';

  double promedio = 0;
  double promedioSemanal = 0;
  double maximo = 0;
  double minimo = 0;
  String riesgo = 'Sin datos';

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  String interpretarGlucosa(double valor, String tipo) {
    if (valor < 70) {
      return 'Hipoglucemia';
    }

    if (tipo == 'Ayunas') {
      if (valor < 100) return 'Normal en ayunas';
      if (valor < 126) return 'Alteración en ayunas';
      return 'Alta en ayunas';
    }

    if (tipo == 'Postprandial') {
      if (valor < 140) return 'Normal post comida';
      if (valor < 180) return 'Elevación post comida';
      return 'Hiperglucemia post comida';
    }

    if (valor <= 180) return 'En rango';
    return 'Alta';
  }
  String interpretarRelacion(double glucosa, int carb) {
    if (glucosa > 180 && carb > 40) {
      return "Posible relación con alta ingesta de carbohidratos.";
    }

    if (glucosa < 70) {
      return "Nivel bajo. Considera ingerir carbohidratos de absorción rápida.";
    }

    if (glucosa >= 70 && glucosa <= 140) {
      return "Buen control en relación a la ingesta.";
    }

    if (glucosa > 140 && glucosa <= 180) {
      return "Elevación moderada. Revisar tipo de carbohidrato o porción.";
    }

    return "Revisar alimentación, ejercicio o estrés.";
  }
  Color colorGlucosa(double valor) {
    if (valor < 70) return Colors.orange;
    if (valor > 180) return Colors.red;
    return Colors.green;
  }

  void calcularEstadisticas() {
    if (mediciones.isEmpty) {
      promedio = 0;
      promedioSemanal = 0;
      maximo = 0;
      minimo = 0;
      riesgo = 'Sin datos';
      return;
    }

    final valores = mediciones.map((e) => e.valor).toList();

    promedio = valores.reduce((a, b) => a + b) / valores.length;
    maximo = valores.reduce((a, b) => a > b ? a : b);
    minimo = valores.reduce((a, b) => a < b ? a : b);

    final ultimos = valores.length >= 7
        ? valores.sublist(valores.length - 7)
        : valores;

    promedioSemanal = ultimos.reduce((a, b) => a + b) / ultimos.length;

    if (promedio < 100) {
      riesgo = '🟢 Buen control promedio';
    } else if (promedio < 126) {
      riesgo = '🟠 Riesgo metabólico';
    } else if (promedio < 180) {
      riesgo = '🔴 Control elevado';
    } else {
      riesgo = '🔴 Hiperglucemia frecuente';
    }
  }

  Future<void> guardarDatos() async {
    final prefs = await SharedPreferences.getInstance();

    final lista = mediciones.map((e) {
      return '${e.valor}|${e.tipo}|${e.comida}|${e.carbohidratos}|${e.observacion}|${e.fecha.millisecondsSinceEpoch}';
    }).toList();

    await prefs.setStringList('glucosa_pro', lista);
  }

  Future<void> cargarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    final datos = prefs.getStringList('glucosa_pro');

    if (datos == null) return;

    setState(() {
      mediciones = datos.map((e) {
        final partes = e.split('|');

        return RegistroGlucosa(
          valor: double.tryParse(partes[0]) ?? 0,
          tipo: partes.length > 1 ? partes[1] : 'Ayunas',
          comida: partes.length > 2 ? partes[2] : 'Sin comida',
          carbohidratos: partes.length > 3 ? partes[3] : '0',
          observacion: partes.length > 4 ? partes[4] : '',
          fecha: partes.length > 5
              ? DateTime.fromMillisecondsSinceEpoch(
            int.tryParse(partes[5]) ?? DateTime.now().millisecondsSinceEpoch,
          )
              : DateTime.now(),
        );
      }).toList();

      calcularEstadisticas();
    });
  }

  void guardarGlucosa() {
    if (glucosaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes ingresar un valor de glucosa.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final valor = double.tryParse(glucosaController.text);

    if (valor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa un número válido.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final nuevoRegistro = RegistroGlucosa(
      valor: valor,
      tipo: tipoMedicion,
      comida: comidaAsociada,
      carbohidratos: carbohidratosController.text.isEmpty
          ? '0'
          : carbohidratosController.text,
      observacion: observacionController.text,
      fecha: DateTime.now(),
    );

    setState(() {
      mediciones.add(nuevoRegistro);
      calcularEstadisticas();
    });

    guardarDatos();

    if (valor < 70) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠ Hipoglucemia: revisa síntomas y consulta si es necesario.'),
          backgroundColor: Colors.orange,
        ),
      );
    } else if (valor > 180) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠ Hiperglucemia: registra contexto y controla evolución.'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro guardado correctamente.'),
          backgroundColor: Colors.green,
        ),
      );
    }

    glucosaController.clear();
    carbohidratosController.clear();
    observacionController.clear();
  }

  void eliminarRegistro(int index) {
    setState(() {
      mediciones.removeAt(index);
      calcularEstadisticas();
    });

    guardarDatos();
  }

  String formatoFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}';
  }

  List<FlSpot> puntosGrafico() {
    return List.generate(
      mediciones.length,
          (index) => FlSpot(
        index.toDouble(),
        mediciones[index].valor,
      ),
    );
  }

  Widget tarjetaResumen(String titulo, String valor, IconData icono, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icono, color: color, size: 28),
              const SizedBox(height: 6),
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                valor,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Glucosa Pro'),
        backgroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Nuevo registro de glucosa',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),

                    TextField(
                      controller: glucosaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Glucosa mg/dL',
                        hintText: 'Ej: 110',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.monitor_heart),
                      ),
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: tipoMedicion,
                      decoration: const InputDecoration(
                        labelText: 'Tipo de medición',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Ayunas', child: Text('Ayunas')),
                        DropdownMenuItem(value: 'Preprandial', child: Text('Preprandial')),
                        DropdownMenuItem(value: 'Postprandial', child: Text('Postprandial')),
                        DropdownMenuItem(value: 'Antes de dormir', child: Text('Antes de dormir')),
                        DropdownMenuItem(value: 'Con síntomas', child: Text('Con síntomas')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          tipoMedicion = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: comidaAsociada,
                      decoration: const InputDecoration(
                        labelText: 'Comida asociada',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Sin comida', child: Text('Sin comida')),
                        DropdownMenuItem(value: 'Desayuno', child: Text('Desayuno')),
                        DropdownMenuItem(value: 'Almuerzo', child: Text('Almuerzo')),
                        DropdownMenuItem(value: 'Snack', child: Text('Snack')),
                        DropdownMenuItem(value: 'Cena', child: Text('Cena')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          comidaAsociada = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: carbohidratosController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Carbohidratos aproximados',
                        hintText: 'Ej: 45 gramos',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.restaurant),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: observacionController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Observación',
                        hintText: 'Ej: después de pan, ejercicio, estrés, mal dormir...',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.note),
                      ),
                    ),

                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: guardarGlucosa,
                        icon: const Icon(Icons.save),
                        label: const Text('Guardar medición'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                tarjetaResumen(
                  'Promedio',
                  mediciones.isEmpty ? '--' : promedio.toStringAsFixed(1),
                  Icons.analytics,
                  Colors.blue,
                ),
                tarjetaResumen(
                  'Máxima',
                  mediciones.isEmpty ? '--' : maximo.toStringAsFixed(0),
                  Icons.arrow_upward,
                  Colors.red,
                ),
                tarjetaResumen(
                  'Mínima',
                  mediciones.isEmpty ? '--' : minimo.toStringAsFixed(0),
                  Icons.arrow_downward,
                  Colors.orange,
                ),
              ],
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.health_and_safety, color: Colors.pink),
                title: const Text(
                  'Estado metabólico',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(riesgo),
              ),
            ),

            const SizedBox(height: 12),

            if (mediciones.length >= 2)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Evolución de glucosa',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        height: 220,
                        child: LineChart(
                          LineChartData(
                            minY: 40,
                            maxY: 300,
                            titlesData: FlTitlesData(show: false),
                            borderData: FlBorderData(show: true),
                            lineBarsData: [
                              LineChartBarData(
                                spots: puntosGrafico(),
                                isCurved: true,
                                color: Colors.pink,
                                barWidth: 3,
                                dotData: FlDotData(show: true),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Detalle de puntos del gráfico:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(mediciones.length, (index) {
                          final m = mediciones[index];

                          return Text(
                            '${index + 1} → ${formatoFecha(m.fecha)} (${m.tipo})',
                            style: const TextStyle(fontSize: 13),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Historial de mediciones',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            mediciones.isEmpty
                ? const Card(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Text(
                  'Aún no hay mediciones registradas.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mediciones.length,
              itemBuilder: (context, index) {
                final item = mediciones[index];

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: colorGlucosa(item.valor),
                      child: const Icon(
                        Icons.bloodtype,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      '${item.valor.toStringAsFixed(0)} mg/dL - ${interpretarGlucosa(item.valor, item.tipo)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorGlucosa(item.valor),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${item.tipo} | ${item.comida}'),
                        Text('🍞 Carbohidratos: ${item.carbohidratos} g'),
                        Text('📅 ${formatoFecha(item.fecha)}'),
                        Text('📝 ${item.observacion}'),
                        const SizedBox(height: 4),

                        Text(
                          interpretarGlucosa(item.valor, item.tipo),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        Text( interpretarRelacion(
                          item.valor,
                          int.tryParse(item.carbohidratos) ?? 0,
                        ),

                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => eliminarRegistro(index),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RegistroGlucosa {
  final double valor;
  final String tipo;
  final String comida;
  final String carbohidratos;
  final String observacion;
  final DateTime fecha;

  RegistroGlucosa({
    required this.valor,
    required this.tipo,
    required this.comida,
    required this.carbohidratos,
    required this.observacion,
    required this.fecha,
  });
}
