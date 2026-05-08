import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'inicio.dart';
import 'autocuidados.dart';
import 'educacion.dart';
import 'medicamentos.dart';
import 'alertas.dart';
import 'dispositivos.dart';
import 'reportes.dart';
import 'comunidad.dart';
import 'minicurso.dart';
import 'glucosapro.dart';
import 'agua.dart';
import 'sueno.dart';
import 'alimentacion.dart';
import 'ejercicio.dart';
import 'menu_diabetico.dart';
import 'adulto_mayor.dart';
import 'riesgo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('comidasBox');
  await Hive.openBox('hidratacionBox');
  await Hive.openBox('suenoBox');
  await Hive.openBox('ejercicioBox');
  await Hive.openBox('menusBox');
  await Hive.openBox('medicamentosBox');
  await Hive.openBox('alimentosUsuarioBox');


  runApp(const GlucoCheckApp());
}

class GlucoCheckApp extends StatelessWidget {
  const GlucoCheckApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi Autochequeo Diabetes',
      home: const InicioPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  void abrirPagina(BuildContext context, Widget pagina) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => pagina),
    );
  }

  Widget boton(String titulo, String icono, Color color, VoidCallback accion) {
    return GestureDetector(
      onTap: accion,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  icono,
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text("GlucoCheck"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          children: [
            boton("Medir glucosa", "assets/icons/glucosa.png", Colors.red,
                    () => abrirPagina(context, const GlucosaPage())),

            boton("Dispositivos", "assets/icons/dispositivos.png", Colors.cyan,
                    () => abrirPagina(context, const DispositivosPage())),

            boton("Alimentación", "assets/icons/icon_alimentacion.png", Colors.green,
                    () => abrirPagina(context, const AlimentacionPage())),

            boton("Menús 7 días", "assets/icons/horarios.png", Colors.teal,
                    () => abrirPagina(context, const MenuDiabeticoPage())),

            boton("Movimiento", "assets/icons/ejercicio.png", Colors.orange,
                    () => abrirPagina(context, const EjercicioPage())),

            boton("Adulto mayor", "assets/icons/adulto_mayor.png", Colors.purple,
                    () => abrirPagina(context, const AdultoMayorPage())),

            boton("Mi resumen", "assets/icons/reportes.png", Colors.blue,
                    () => abrirPagina(context, const ReportesPage())),

            boton("Medicamentos", "assets/icons/medicamentos.png", Colors.pink,
                    () => abrirPagina(context, const MedicamentosPage())),

            boton("Agua", "assets/icons/agua.png", Colors.blue,
                    () => abrirPagina(context, const AguaPage())),

            boton("Sueño", "assets/icons/sueno.png", Colors.indigo,
                    () => abrirPagina(context, const SuenoPage())),

            boton("Riesgo", "assets/icons/reportes.png", Colors.indigo,
                    () => abrirPagina(context, const RiesgoPage())),

            boton("Autocuidados", "assets/icons/autocuidados.png", Colors.pink,
                    () => abrirPagina(context, const AutocuidadosPage())),
          ],
        ),
      ),
    );
  }
}