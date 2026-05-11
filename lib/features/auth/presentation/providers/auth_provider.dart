import 'package:flutter/material.dart';
import '../../data/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  // Variable de estado que la pantalla va a "escuchar"
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Lógica de negocio encapsulada
  Future<Map<String, dynamic>> login(String email, String password) async {
    // 1. Avisar a la pantalla que empezamos a cargar
    _isLoading = true;
    notifyListeners();

    // 2. Llamar al backend
    final response = await _authService.login(email, password);

    // 3. Avisar a la pantalla que terminamos de cargar
    _isLoading = false;
    notifyListeners();

    // 4. Retornar la respuesta para que la pantalla decida si navega o muestra error
    return response;
  }
}
