import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tex/flutter_tex.dart';
import '../providers/quiz_provider.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();

    if (provider.preguntaActual == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final pregunta = provider.preguntaActual!;

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
                Text('Racha: ${provider.racha}'),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 4),
                Text('Monedas: ${provider.monedas}'),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TeXView(
                  child: TeXViewDocument(pregunta.enunciado),
                  style: const TeXViewStyle(
                    contentColor: Colors.black,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () => provider.evaluarRespuesta(pregunta.opcionA, 15),
                  child: Text(pregunta.opcionA),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => provider.evaluarRespuesta(pregunta.opcionB, 15),
                  child: Text(pregunta.opcionB),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => provider.evaluarRespuesta(pregunta.opcionC, 15),
                  child: Text(pregunta.opcionC),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}