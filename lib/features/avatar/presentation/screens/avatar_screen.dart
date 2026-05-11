import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:math_ia/core/constants/item_catalog.dart';
import 'package:math_ia/core/providers/user_provider.dart';

class AvatarScreen extends StatelessWidget {
  const AvatarScreen({super.key});

  Widget _buildInventoryGrid(BuildContext context, String categoryName) {
    final user = context.watch<UserProvider>();
    List<dynamic> ownedIds = user.inventory[categoryName] ?? [];

    if (ownedIds.isEmpty) {
      return const Center(
        child: Text('Aún no tienes objetos aquí. ¡Ve a la tienda!'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: ownedIds.length,
      itemBuilder: (context, index) {
        String itemId = ownedIds[index];
        Map<String, dynamic>? item = ItemCatalog.getItemById(
          categoryName,
          itemId,
        );
        if (item == null) return const SizedBox();

        bool isEquipped = user.equipped[categoryName] == itemId;

        return GestureDetector(
          onTap: () =>
              context.read<UserProvider>().toggleEquip(categoryName, itemId),
          child: Container(
            decoration: BoxDecoration(
              color: isEquipped ? Colors.blue.withOpacity(0.2) : Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isEquipped ? Colors.blue : Colors.grey.shade300,
                width: isEquipped ? 3 : 1,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // --- MOSTRAMOS EL PNG DEL INVENTARIO ---
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(item['iconPath'], fit: BoxFit.contain),
                ),

                if (isEquipped)
                  const Positioned(
                    top: 4,
                    right: 4,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();

    final equippedHat = ItemCatalog.getItemById(
      'hats',
      user.equipped['hats'] ?? '',
    );
    final equippedGlass = ItemCatalog.getItemById(
      'glasses',
      user.equipped['glasses'] ?? '',
    );
    final equippedShirt = ItemCatalog.getItemById(
      'shirts',
      user.equipped['shirts'] ?? '',
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue.shade900, Colors.blue.shade300],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Taller de Ensamblaje',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- EL ROBOT CON IMÁGENES REALES ---
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: AspectRatio(
                          aspectRatio:
                              1, // Obliga a que el contenedor sea siempre un cuadrado perfecto
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // 1. Capa base: El cuerpo del robot
                              Image.asset(
                                'assets/images/robot_base.png',
                                fit: BoxFit
                                    .contain, // contain asegura que no se recorte
                              ),

                              // 2. Capa de ropa (Chasis)
                              if (equippedShirt != null)
                                Image.asset(
                                  equippedShirt['imagePath'],
                                  fit: BoxFit.contain,
                                ),

                              // 3. Capa de rostro (Lentes)
                              if (equippedGlass != null)
                                Image.asset(
                                  equippedGlass['imagePath'],
                                  fit: BoxFit.contain,
                                ),

                              // 4. Capa de cabeza (Sombrero)
                              if (equippedHat != null)
                                Image.asset(
                                  equippedHat['imagePath'],
                                  fit: BoxFit.contain,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // ... (La parte del TabBar del Armario queda igual que antes)

          // ZONA INFERIOR: ARMARIO
          Expanded(
            flex: 6,
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const TabBar(
                    indicatorColor: Colors.blueAccent,
                    labelColor: Colors.blueAccent,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(icon: Icon(Icons.sports_baseball), text: 'Cabeza'),
                      Tab(icon: Icon(Icons.remove_red_eye), text: 'Rostro'),
                      Tab(icon: Icon(Icons.checkroom), text: 'Cuerpo'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildInventoryGrid(context, 'hats'),
                        _buildInventoryGrid(context, 'glasses'),
                        _buildInventoryGrid(context, 'shirts'),
                      ],
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
