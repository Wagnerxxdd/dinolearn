import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/avatar_controller.dart';

class RecompensasGradeView extends StatelessWidget {
  const RecompensasGradeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AvatarController controller = Get.find<AvatarController>();

    final List<Map<String, dynamic>> items = [
      {
        'id': 1,
        'name': 'Boné Dino',
        'image': 'assets/images/avatars/bone_dino.png',
        'icon': Icons.theater_comedy,
      },
      {
        'id': 2,
        'name': 'Óculos',
        'image': 'assets/images/avatars/oculos.png',
        'icon': Icons.visibility,
      },
      {
        'id': 3,
        'name': 'Fone',
        'image': 'assets/images/avatars/fone.png',
        'icon': Icons.headset,
      },
      {
        'id': 4,
        'name': 'Mochila',
        'image': 'assets/images/avatars/mochila.png',
        'icon': Icons.backpack,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: const Text(
          'Meus Prêmios',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF2D5A58),
      ),
      body: Obx(() {
        // A leitura precisa acontecer diretamente no builder do Obx.
        // O itemBuilder da grade e executado de forma tardia pelo Flutter.
        final unlockedIds = controller.unlockedItems
            .map((item) => item.id)
            .whereType<int>()
            .toSet();

        return GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.8,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final isUnlocked = unlockedIds.contains(item['id'] as int);
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isUnlocked ? item['icon'] : Icons.lock,
                    size: 60,
                    color: isUnlocked
                        ? const Color(0xFF34677E)
                        : Colors.grey.shade300,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item['name'] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isUnlocked ? Colors.black87 : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (isUnlocked)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Desbloqueado",
                        style: TextStyle(
                          color: Colors.teal,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    Text(
                      item['id'] == 1
                          ? "Complete os 3 blocos"
                          : "Recompensa futura",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
