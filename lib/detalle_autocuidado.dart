import 'package:flutter/material.dart';
import 'detalle_autocuidado.dart';
class DetalleAutocuidadoPage extends StatelessWidget {
  final String titulo;
  final String texto;

  const DetalleAutocuidadoPage({
    super.key,
    required this.titulo,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              texto,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}