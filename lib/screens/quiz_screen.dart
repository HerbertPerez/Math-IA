import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tex/flutter_tex.dart';
import '../providers/quiz_provider.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchamos al provider
    final provider = context.watch<QuizProvider>();

    // Si la preguntaActual todavía es nula (porque la BD está cargando)
    // mostramos una pantalla de carga bonita en lugar de dejar que explote en rojo
    if (provider.preguntaActual == null) {}

    final pregunta = provider.preguntaActual;
    if (pregunta == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Cargando..."),
          backgroundColor: const Color(0xFF4A69FF),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A69FF),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.local_fire_department, color: Colors.orange),
                const SizedBox(width: 4),
                Text(
                  'Racha: ${provider.racha}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  'Monedas: ${provider.monedas}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
      // Usamos un SingleChildScrollView para evitar los errores de "Overflow"
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 4,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  // Le damos una altura fija para que TeXView no rompa el diseño
                  height: 250,
                  width: double.infinity,
                  child: Text(pregunta.enunciado),
                ),
              ),
              const SizedBox(height: 30),
              _buildOptionButton(context, provider, pregunta.opcionA),
              const SizedBox(height: 12),
              _buildOptionButton(context, provider, pregunta.opcionB),
              const SizedBox(height: 12),
              _buildOptionButton(context, provider, pregunta.opcionC),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(
    BuildContext context,
    QuizProvider provider,
    String texto,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          backgroundColor: Colors.white,
          foregroundColor: Colors.blueAccent,
          side: const BorderSide(color: Colors.blueAccent),
        ),
        onPressed: () => provider.evaluarRespuesta(texto, 15),
        child: Text(texto, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
