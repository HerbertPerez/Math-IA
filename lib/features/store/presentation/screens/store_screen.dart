import 'package:flutter/material.dart';
import 'package:math_ia/core/constants/item_catalog.dart';
import 'package:math_ia/core/providers/user_provider.dart';
import 'package:provider/provider.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  // Mostramos el diálogo de compra
  void _showPurchaseConfirmDialog(
    BuildContext context,
    String category,
    Map<String, dynamic> item,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Confirmar Compra', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                item['iconPath'],
                height: 60, // Le damos un alto fijo para que no se deforme
                width: 60,
                fit: BoxFit
                    .contain, // Asegura que la imagen mantenga su proporción
              ),
              const SizedBox(height: 16),
              Text(
                '¿Comprar "${item['name']}"?',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.monetization_on, color: Colors.amber),
                  Text(
                    ' ${item['price']}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Cierra el popup

                // Intentamos comprar usando el Provider
                bool success = context.read<UserProvider>().buyItem(
                  category,
                  item['id'],
                  item['price'],
                );

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('¡${item['name']} comprado!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No tienes monedas suficientes'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              child: const Text('Comprar'),
            ),
          ],
        );
      },
    );
  }

  // Genera la grilla evaluando si el usuario ya tiene el item
  Widget _buildStoreGrid(BuildContext context, String categoryName) {
    final user = context.watch<UserProvider>();
    final List<Map<String, dynamic>> categoryItems =
        ItemCatalog.items[categoryName] ?? [];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: categoryItems.length,
      itemBuilder: (context, index) {
        final item = categoryItems[index];

        // Verificamos si el inventario del usuario contiene este ID
        List<dynamic> userInventory = user.inventory[categoryName] ?? [];
        bool isOwned = userInventory.contains(item['id']);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                item['iconPath'],
                height: 60, // Le damos un alto fijo para que no se deforme
                width: 60,
                fit: BoxFit
                    .contain, // Asegura que la imagen mantenga su proporción
              ),
              Text(
                item['name'],
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              // Si ya lo tiene, mostramos un check. Si no, el botón de precio.
              isOwned
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 18),
                        SizedBox(width: 4),
                        Text(
                          'Comprado',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : ElevatedButton.icon(
                      onPressed: () => _showPurchaseConfirmDialog(
                        context,
                        categoryName,
                        item,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade100,
                        foregroundColor: Colors.orange.shade900,
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.monetization_on, size: 18),
                      label: Text('${item['price']}'),
                    ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();

    return DefaultTabController(
      length: 3, // Sombreros, Anteojos, Polos
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Tienda',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          // Mostramos las monedas en tiempo real en la tienda
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.monetization_on, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    '${user.coins}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.blueAccent,
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: Icon(Icons.sports_baseball), text: 'Sombreros'),
              Tab(icon: Icon(Icons.remove_red_eye), text: 'Anteojos'),
              Tab(icon: Icon(Icons.checkroom), text: 'Polos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildStoreGrid(context, 'hats'),
            _buildStoreGrid(context, 'glasses'),
            _buildStoreGrid(context, 'shirts'),
          ],
        ),
      ),
    );
  }
}
