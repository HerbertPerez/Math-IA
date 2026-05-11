import 'package:flutter/material.dart';

class ExamsScreen extends StatelessWidget {
  const ExamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Examen de Matemáticas',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
