class ItemCatalog {
  static final Map<String, List<Map<String, dynamic>>> items = {
    'hats': [
      {
        'id': 'h1',
        'name': 'Gorra de Novato',
        'imagePath': 'assets/images/sprites/hat_1.png',
        'iconPath': 'assets/images/icons/icon_hat_1.png',
        'price': 100,
      },
      {
        'id': 'h2',
        'name': 'Corona Real',
        'imagePath': 'assets/images/sprites/hat_2.png',
        'iconPath': 'assets/images/icons/icon_hat_2.png',
        'price': 350,
      },
    ],
    'glasses': [
      {
        'id': 'g1',
        'name': 'Lentes Básicos',
        'imagePath': 'assets/images/sprites/glass_1.png',
        'iconPath': 'assets/images/icons/icon_glass_1.png',
        'price': 0,
      },
      {
        'id': 'g2',
        'name': 'Visor VR',
        'imagePath': 'assets/images/sprites/glass_2.png',
        'iconPath': 'assets/images/icons/icon_glass_2.png',
        'price': 400,
      },
    ],
    'shirts': [
      {
        'id': 's1',
        'name': 'Chasis Simple',
        'imagePath': 'assets/images/sprites/shirt_1.png',
        'iconPath': 'assets/images/icons/icon_shirt_1.png',
        'price': 0,
      },
      {
        'id': 's2',
        'name': 'Armadura',
        'imagePath': 'assets/images/sprites/shirt_2.png',
        'iconPath': 'assets/images/icons/icon_shirt_2.png',
        'price': 600,
      },
    ],
  };

  static Map<String, dynamic>? getItemById(String category, String id) {
    try {
      return items[category]?.firstWhere((item) => item['id'] == id);
    } catch (e) {
      return null;
    }
  }
}
