import 'dart:math';
import 'package:flutter/material.dart';
import '../models/modelos.dart';
import '../database/database_helper.dart';

class QuizProvider extends ChangeNotifier {
  Pregunta? preguntaActual;
  int monedas = 0;
  int racha = 0;

  Future<void> iniciarQuiz() async {
    try {
      // Agregamos un pequeño delay de seguridad para que la UI respire
      await Future.delayed(const Duration(milliseconds: 500));

      final dbHelper = DatabaseHelper();
      await dbHelper.cargarPreguntasIniciales();
      await cargarPregunta();
    } catch (e) {
      debugPrint("Error al iniciar base de datos: $e");
    }
  }

  Future<void> cargarPregunta() async {
    final preguntas = await DatabaseHelper().obtenerPreguntas();
    if (preguntas.isNotEmpty) {
      final random = Random();
      preguntaActual = preguntas[random.nextInt(preguntas.length)];
      notifyListeners();
    }
  }

  Future<void> evaluarRespuesta(
    String respuestaSeleccionada,
    int tiempoSegundos,
  ) async {
    if (preguntaActual == null) return;
    bool esCorrecta =
        respuestaSeleccionada == preguntaActual!.respuestaCorrecta;
    if (esCorrecta) {
      monedas += 10;
      racha += 1;
    } else {
      racha = 0;
    }
    final progreso = Progreso(
      id: 0,
      preguntaId: preguntaActual!.id,
      acierto: esCorrecta ? 1 : 0,
      tiempoSegundos: tiempoSegundos,
    );
    await DatabaseHelper().insertarProgreso(progreso);
    await cargarPregunta();
  }
}
