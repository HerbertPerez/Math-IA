import 'package:flutter/material.dart';
import 'package:math_ia/core/providers/user_provider.dart';
import 'package:provider/provider.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  // --- FUNCIÓN PARA MOSTRAR EL POPUP DE JUEGOS ---
  void _showGamesPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            // Limitamos el tamaño del popup
            constraints: const BoxConstraints(maxHeight: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cabecera del Popup con Título y Botón de Cerrar (X)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Elige un Juego',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () =>
                          Navigator.of(context).pop(), // Cierra el popup
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 10),

                // Lista de Juegos (Cuadritos)
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2, // Dos columnas
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      _buildGameCard(
                        context,
                        title: 'Álgebra\nRápida',
                        icon: Icons.calculate,
                        color: Colors.blueAccent,
                      ),
                      _buildGameCard(
                        context,
                        title: 'Reto\nGeometría',
                        icon: Icons.category,
                        color: Colors.orangeAccent,
                      ),
                      _buildGameCard(
                        context,
                        title: 'Lógica\nIA',
                        icon: Icons.psychology,
                        color: Colors.purpleAccent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- WIDGET REUTILIZABLE PARA LAS TARJETAS DE JUEGO ---
  Widget _buildGameCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        // Aquí agregarías la navegación hacia el juego seleccionado
        // Navigator.pop(context); // Cierra el popup primero
        // Navigator.push(...); // Navega al juego
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Iniciando $title...')));
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos el usuario en tiempo real
    final user = context.watch<UserProvider>();

    return SafeArea(
      child: Column(
        children: [
          // 1. --- CABECERA DE ESTADÍSTICAS ---
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Bloque Izquierdo: Nick, Nivel y Experiencia
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'Lvl ${user.level}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 8),
                          // Barra de experiencia
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: user.currentLevelExp / user.maxLevelExp,
                                minHeight: 8,
                                backgroundColor: Colors.grey[300],
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${user.maxLevelExp}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Bloque Central: Monedas y Vidas
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.monetization_on,
                          color: Colors.amber,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${user.coins}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.favorite, color: Colors.red, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${user.lives}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),

                // Bloque Derecho: Botón de Configuración (Tres rayitas)
                IconButton(
                  icon: const Icon(Icons.menu, size: 28),
                  onPressed: () {
                    // Acción para abrir configuraciones
                  },
                ),
              ],
            ),
          ),

          // 2. --- ZONA CENTRAL (AVATAR Y BOTÓN DE JUGAR) ---
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Avatar del usuario (Icono gigante por ahora)
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue, width: 4),
                    ),
                    child: const Icon(
                      Icons.face_retouching_natural,
                      size: 100,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Botón Gigante "Jugar Ya"
                  SizedBox(
                    width: 250,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () => _showGamesPopup(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.green, // Color que llama a la acción
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        'JUGAR YA',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
