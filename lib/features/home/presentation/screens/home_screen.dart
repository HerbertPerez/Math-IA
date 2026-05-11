import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importamos el Provider
import '../providers/home_provider.dart';

// Importamos todas nuestras pantallas
import '../../../store/presentation/screens/store_screen.dart';
import '../../../avatar/presentation/screens/avatar_screen.dart';
import '../../../math_challenges/presentation/screens/games_screen.dart';
import '../../../friends/presentation/screens/friends_screen.dart';
import '../../../exams/presentation/screens/exams_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchamos el índice actual desde el Provider
    final currentIndex = context.watch<HomeProvider>().currentIndex;

    // Lista de las pantallas en el orden exacto de los botones
    final List<Widget> screens = [
      const StoreScreen(), // Índice 0
      const AvatarScreen(), // Índice 1
      const GamesScreen(), // Índice 2 (Por defecto)
      const FriendsScreen(), // Índice 3
      const ExamsScreen(), // Índice 4
    ];

    return Scaffold(
      // IndexedStack mantiene el estado de las pantallas en memoria
      body: IndexedStack(index: currentIndex, children: screens),

      // La barra de navegación inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          // Cambiamos el estado usando el Provider
          context.read<HomeProvider>().changeTab(index);
        },
        type: BottomNavigationBarType.fixed, // Necesario cuando hay > 3 items
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront),
            label: 'Tienda',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Avatar'),
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset), // o Icons.gamepad
            label: 'Juegos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Amigos'),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Examen',
          ),
        ],
      ),
    );
  }
}
