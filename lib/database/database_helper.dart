import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/modelos.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'educativo.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE preguntas (
            id INTEGER PRIMARY KEY,
            enunciado TEXT,
            opcion_a TEXT,
            opcion_b TEXT,
            opcion_c TEXT,
            respuesta_correcta TEXT,
            dificultad INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE progreso (
            id INTEGER PRIMARY KEY,
            pregunta_id INTEGER,
            acierto INTEGER,
            tiempo_segundos INTEGER
          )
        ''');
      },
    );
  }

  Future<void> cargarPreguntasIniciales() async {
    final db = await database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM preguntas'),
    );
    if (count == 0) {
      await db.insert('preguntas', Pregunta(
        id: 1,
        enunciado: '¿Cuánto es 2 + 2?',
        opcionA: '3',
        opcionB: '4',
        opcionC: '5',
        respuestaCorrecta: '4',
        dificultad: 1,
      ).toMap());
      await db.insert('preguntas', Pregunta(
        id: 2,
        enunciado: '¿Cuánto es 5 - 3?',
        opcionA: '2',
        opcionB: '3',
        opcionC: '4',
        respuestaCorrecta: '2',
        dificultad: 1,
      ).toMap());
      await db.insert('preguntas', Pregunta(
        id: 3,
        enunciado: '¿Cuánto es 3 x 3?',
        opcionA: '6',
        opcionB: '9',
        opcionC: '12',
        respuestaCorrecta: '9',
        dificultad: 1,
      ).toMap());
    }
  }

  Future<List<Pregunta>> obtenerPreguntas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('preguntas');
    return List.generate(maps.length, (i) => Pregunta.fromMap(maps[i]));
  }

  Future<void> insertarProgreso(Progreso progreso) async {
    final db = await database;
    await db.insert('progreso', progreso.toMap());
  }
}