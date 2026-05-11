import 'dart:convert';
import 'dart:async'; // ¡Importante agregar esto!
import 'package:http/http.dart' as http;

class AuthService {
  // Reemplaza esto con la URL real de tu backend.
  // Si usas un emulador de Android y tu backend está en tu PC local, usa 'http://10.0.2.2:3000'
  final String _baseUrl = 'http://localhost:3000/api';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final url = Uri.parse('$_baseUrl/login');

      // Realizamos la petición POST al servidor
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      // Verificamos si el servidor respondió con un código de éxito (200 OK)
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        // Aquí normalmente el backend devuelve un Token (JWT)
        // String token = decodedData['token'];

        return {
          'success': true,
          'message': 'Login exitoso',
          'data': decodedData,
        };
      } else {
        // Manejamos errores (ej. 401 No Autorizado, 404 No Encontrado)
        final decodedError = jsonDecode(response.body);
        return {
          'success': false,
          'message': decodedError['message'] ?? 'Credenciales incorrectas',
        };
      }
    } catch (e) {
      // Manejamos errores de red (ej. sin internet, servidor caído)
      return {
        'success': false,
        'message': 'Error de conexión: Verifica tu internet o el servidor.',
      };
    }
  }

  Future<Map<String, dynamic>> register(
    String email,
    String name,
    String password,
  ) async {
    try {
      final url = Uri.parse('$_baseUrl/register');

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'email': email,
              'name': name,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        return {
          'success': true,
          'message': decodedData['message'] ?? 'Registro exitoso',
          'data': decodedData, // Añadimos esta línea vital para atrapar el ID
        };
      } else {
        final decodedError = jsonDecode(response.body);
        return {
          'success': false,
          'message': decodedError['message'] ?? 'Error al registrar',
        };
      }
    } on TimeoutException catch (_) {
      return {
        'success': false,
        'message': 'El servidor tardó demasiado en responder.',
      };
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión.'};
    }
  }

  // ==========================================
  // SOLICITAR CÓDIGO (Olvidé contraseña)
  // ==========================================
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/forgot-password'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email}),
          )
          .timeout(const Duration(seconds: 10));

      final decodedData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': decodedData['message']};
      } else {
        return {
          'success': false,
          'message': decodedData['message'] ?? 'Error al solicitar el código',
        };
      }
    } on TimeoutException catch (_) {
      return {
        'success': false,
        'message': 'El servidor tardó demasiado en responder.',
      };
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión.'};
    }
  }

  // ==========================================
  // RESETEAR CONTRASEÑA (Validar código)
  // ==========================================
  Future<Map<String, dynamic>> resetPassword(
    String email,
    String code,
    String newPassword,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/reset-password'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'code': code,
              'new_password': newPassword,
            }),
          )
          .timeout(const Duration(seconds: 10));

      final decodedData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': decodedData['message']};
      } else {
        return {
          'success': false,
          'message': decodedData['message'] ?? 'Error al cambiar la contraseña',
        };
      }
    } on TimeoutException catch (_) {
      return {
        'success': false,
        'message': 'El servidor tardó demasiado en responder.',
      };
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión.'};
    }
  }
}
