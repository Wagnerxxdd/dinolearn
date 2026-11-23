import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/perfil.dart';
import '../../../utils/app_constants.dart';
import '../../../routes/app_routes.dart';
import '../../../controllers/perfil_controller.dart';
import '../../../controllers/avatar_controller.dart';

class ProfileCard extends StatelessWidget {
  final Perfil perfil;

  const ProfileCard({Key? key, required this.perfil}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Get.find<PerfilController>().selecionarPerfil(perfil);
        await Get.find<AvatarController>().loadAvatarData();
        Get.toNamed(AppRoutes.criancaDashboard);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppConstants.primaryDark.withOpacity(0.5),
                  width: 2.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppConstants.coresSuaves[perfil.corPreferida] ?? Colors.blue.shade50,
                  ),
                  child: Center(
                    child: Text(
                      perfil.nome.isNotEmpty ? perfil.nome[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryDark,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              perfil.nome,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
