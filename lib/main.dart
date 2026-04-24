import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/quiz_screen.dart';
import 'providers/quiz_provider.dart';

Future<void> main() async {
  // 1. Aseguramos la inicialización de Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Esperamos un segundo para que el sistema operativo Android termine de cargar
  await Future.delayed(const Duration(seconds: 1));

  runApp(
    ChangeNotifierProvider(
      create: (context) => QuizProvider()..iniciarQuiz(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const QuizScreen(),
    );
  }
}
