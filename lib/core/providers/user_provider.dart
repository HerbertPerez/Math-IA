import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {
  // Configura tu URL de FastAPI
  final String _baseUrl = 'http://localhost:3000/api';

  // Datos del usuario en memoria
  int _userId = 0;
  String _name = "";
  int _exp = 0;
  int _coins = 0;
  int _lives = 5;

  Map<String, dynamic> _inventory = {};
  Map<String, dynamic> _equipped = {};

  // --- LÓGICA DE NIVELES (Curva de progresión) ---
  final int _baseExp = 100; // Cuánto cuesta el Nivel 1
  final double _multiplier = 1.5; // Qué tan difícil se vuelve cada nivel

  // Getters para que la UI lea los datos
  String get name => _name;
  // int get level => _level;
  // 1. Calcula en qué nivel estás basado en tu Experiencia Total
  int get level {
    int lvl = 1;
    int expNeeded = _baseExp;
    int tempExp = _exp;

    while (tempExp >= expNeeded) {
      lvl++;
      tempExp -= expNeeded;
      expNeeded = (expNeeded * _multiplier)
          .toInt(); // El próximo nivel cuesta más
    }
    return lvl;
  }

  // 2. Calcula cuánta experiencia llevas EN TU NIVEL ACTUAL
  int get currentLevelExp {
    int expNeeded = _baseExp;
    int tempExp = _exp;

    while (tempExp >= expNeeded) {
      tempExp -= expNeeded;
      expNeeded = (expNeeded * _multiplier).toInt();
    }
    return tempExp; // Es el "sobrante"
  }

  // 3. Calcula cuánta experiencia PIDE TU NIVEL ACTUAL
  int get maxLevelExp {
    int lvl = level;
    int expNeeded = _baseExp;
    for (int i = 1; i < lvl; i++) {
      expNeeded = (expNeeded * _multiplier).toInt();
    }
    return expNeeded;
  }

  int get exp => _exp;
  int get coins => _coins;
  int get lives => _lives;
  Map<String, dynamic> get inventory => _inventory;
  Map<String, dynamic> get equipped => _equipped;

  // 1. CARGAR DATOS (Se llama después de un Login exitoso)
  Future<void> fetchUserData(int id) async {
    _userId = id;
    try {
      final response = await http.get(Uri.parse('$_baseUrl/users/$_userId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _name = data['name'];
        _exp = data['exp'];
        _coins = data['coins'];
        _lives = data['lives'];
        _inventory = data['inventory'];
        _equipped = data['equipped'];
        notifyListeners(); // Actualiza todas las pantallas
      }
    } catch (e) {
      debugPrint("Error cargando usuario: $e");
    }
  }

  // 2. COMPRAR UN ITEM (Desde la Tienda)
  bool buyItem(String category, String itemId, int price) {
    if (_coins >= price) {
      _coins -= price; // Restar monedas
      List<dynamic> categoryItems = _inventory[category] ?? [];
      categoryItems.add(itemId); // Agregar al inventario
      _inventory[category] = categoryItems;

      notifyListeners();
      _syncWithBackend(); // Guardar en PostgreSQL
      return true; // Compra exitosa
    }
    return false; // No tiene dinero
  }

  // 3. EQUIPAR/DESEQUIPAR UN ITEM (Desde el Avatar)
  void toggleEquip(String category, String itemId) {
    // category en DB: "hat", "glass", "shirt"
    if (_equipped[category] == itemId) {
      _equipped[category] = null; // Se lo quita
    } else {
      _equipped[category] = itemId; // Se lo pone
    }
    notifyListeners();
    _syncWithBackend(); // Guardar en PostgreSQL
  }

  // 4. SINCRONIZAR CON FASTAPI (Fondo / Silencioso)
  Future<void> _syncWithBackend() async {
    if (_userId == 0) return;
    try {
      await http.put(
        Uri.parse('$_baseUrl/users/$_userId/sync'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'coins': _coins,
          'inventory': _inventory,
          'equipped': _equipped,
        }),
      );
    } catch (e) {
      debugPrint("Error sincronizando: $e");
    }
  }
}
