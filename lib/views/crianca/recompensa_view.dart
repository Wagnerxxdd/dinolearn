import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../../controllers/avatar_controller.dart';

class RecompensaView extends StatelessWidget {
  const RecompensaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final avatarCtrl = Get.find<AvatarController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Parabéns! 🎉",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D5A58),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Você ganhou uma nova recompensa!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const SizedBox(height: 40),

              // Imagem da Recompensa (Boné Dino)
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFC7EFE5), width: 8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/avatars/bone_dino.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.theater_comedy,
                    size: 100,
                    color: Color(0xFF34677E),
                  ),
                ),
              ),

              const SizedBox(height: 30),
              const Text(
                "Boné de Dinossauro",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  await avatarCtrl.loadAvatarData();
                  final bone = avatarCtrl.allItems.firstWhereOrNull(
                        (item) => item.id == 1,
                  );

                  if (bone == null || !avatarCtrl.isUnlocked(1)) {
                    Get.snackbar(
                      'Recompensa indisponível',
                      'Não foi possível carregar o Boné Dino. Volte ao painel e tente novamente.',
                    );
                    return;
                  }

                  if (!avatarCtrl.isEquipped(1)) {
                    await avatarCtrl.toggleEquipar(bone);
                  }

                  Get.snackbar(
                    'Item Equipado!',
                    'Seu avatar agora está usando o Boné Dino!',
                    backgroundColor: Colors.teal.shade100,
                    colorText: Colors.teal.shade900,
                  );
                  Get.offNamed(AppRoutes.criancaResumoJornada);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF34677E),
                  minimumSize: const Size(double.infinity, 64),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Equipar agora",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Get.offNamed(AppRoutes.criancaResumoJornada),
                child: const Text(
                  "Equipar depois",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
