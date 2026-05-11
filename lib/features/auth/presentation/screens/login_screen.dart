import 'package:flutter/material.dart';
import 'package:math_ia/core/providers/user_provider.dart';
import 'package:math_ia/features/home/presentation/screens/home_screen.dart';
import 'package:provider/provider.dart'; // Importante importar provider
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    // Usamos context.read para ejecutar la acción sin escuchar cambios constantes
    final authProvider = context.read<AuthProvider>();

    final response = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (response['success']) {
      // Login exitoso: Navegar al Home
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bienvenido'),
          backgroundColor: Colors.green,
        ),
      );

      // Extraes el ID del usuario que viene en tu respuesta del login
      int userId = response['data']['user']['id'];

      // Mandas a cargar sus monedas e inventario
      await context.read<UserProvider>().fetchUserData(userId);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false, // Destruye todas las rutas previas
      );
    } else {
      // Error: Mostrar mensaje del backend
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Usamos context.watch para re-dibujar la UI cuando isLoading cambie
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.lock_person, size: 100, color: Colors.blue),
                  const SizedBox(height: 32),
                  const Text(
                    '¡Bienvenido a Math-IA!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),

                  // Input Correo (Igual que antes)
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Correo',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) => value!.isEmpty ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 16),

                  // Input Contraseña (Igual que antes)
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) => value!.isEmpty ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 32),

                  // El botón ahora reacciona a la variable del Provider
                  ElevatedButton(
                    onPressed: isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(),
                          )
                        : const Text(
                            'Ingresar',
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
