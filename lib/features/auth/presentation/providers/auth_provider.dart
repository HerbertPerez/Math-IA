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

  Future<Map<String, dynamic>> register(
    String email,
    String name,
    String password,
  ) async {
    _isLoading = true;
    notifyListeners();

    final response = await _authService.register(email, name, password);

    _isLoading = false;
    notifyListeners();

    return response;
  }

  // ==========================================
  // SOLICITAR CÓDIGO
  // ==========================================
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    _isLoading = true;
    notifyListeners();

    final response = await _authService.forgotPassword(email);

    _isLoading = false;
    notifyListeners();

    return response;
  }

  // ==========================================
  // RESETEAR CONTRASEÑA
  // ==========================================
  Future<Map<String, dynamic>> resetPassword(
    String email,
    String code,
    String newPassword,
  ) async {
    _isLoading = true;
    notifyListeners();

    final response = await _authService.resetPassword(email, code, newPassword);

    _isLoading = false;
    notifyListeners();

    return response;
  }
}
