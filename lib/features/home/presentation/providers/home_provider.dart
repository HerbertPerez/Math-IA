import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  // Inicializamos en 2 porque: 0=Tienda, 1=Avatar, 2=Juegos, 3=Amigos, 4=Examen
  int _currentIndex = 2;

  int get currentIndex => _currentIndex;

  void changeTab(int index) {
    _currentIndex = index;
    notifyListeners(); // Avisa a la pantalla que debe redibujarse
  }
}
