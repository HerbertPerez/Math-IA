class Pregunta {
  int id;
  String enunciado;
  String opcionA;
  String opcionB;
  String opcionC;
  String respuestaCorrecta;
  int dificultad;

  Pregunta({
    required this.id,
    required this.enunciado,
    required this.opcionA,
    required this.opcionB,
    required this.opcionC,
    required this.respuestaCorrecta,
    required this.dificultad,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'enunciado': enunciado,
      'opcion_a': opcionA,
      'opcion_b': opcionB,
      'opcion_c': opcionC,
      'respuesta_correcta': respuestaCorrecta,
      'dificultad': dificultad,
    };
  }

  factory Pregunta.fromMap(Map<String, dynamic> map) {
    return Pregunta(
      id: map['id'],
      enunciado: map['enunciado'],
      opcionA: map['opcion_a'],
      opcionB: map['opcion_b'],
      opcionC: map['opcion_c'],
      respuestaCorrecta: map['respuesta_correcta'],
      dificultad: map['dificultad'],
    );
  }
}

class Progreso {
  int id;
  int preguntaId;
  int acierto;
  int tiempoSegundos;

  Progreso({
    required this.id,
    required this.preguntaId,
    required this.acierto,
    required this.tiempoSegundos,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pregunta_id': preguntaId,
      'acierto': acierto,
      'tiempo_segundos': tiempoSegundos,
    };
  }

  factory Progreso.fromMap(Map<String, dynamic> map) {
    return Progreso(
      id: map['id'],
      preguntaId: map['pregunta_id'],
      acierto: map['acierto'],
      tiempoSegundos: map['tiempo_segundos'],
    );
  }
}