import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/perfil_controller.dart';
import '../../controllers/atividade_controller.dart';
import '../../utils/app_constants.dart';
import '../../routes/app_routes.dart';
import 'widgets/avatar_layered_display.dart';

class CriancaDashboardView extends StatelessWidget {
  const CriancaDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AtividadeController atividadeController =
    Get.find<AtividadeController>();
    final PerfilController perfilController = Get.find<PerfilController>();

    return Obx(() {
      final perfil = perfilController.perfilSelecionado.value;
      if (perfil == null) {
        return const Scaffold(
          body: Center(child: Text('Erro ao carregar perfil')),
        );
      }
      final backgroundColor =
          AppConstants.coresSuaves[perfil.corPreferida] ??
              const Color(0xFFF8FAFB);
      final scaffoldBackgroundColor = Color.alphaBlend(
        backgroundColor.withValues(alpha: 0.35),
        Colors.white,
      );

      return Scaffold(
        // Mantém o tom suave sem deixar o Scaffold transparente. Em alguns
        // aparelhos, a transparência era composta sobre o fundo escuro da
        // janela e fazia toda a interface parecer desativada.
        backgroundColor: scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Icon(Icons.face_outlined, color: AppConstants.primaryDark),
          ),
          title: const Text(
            'Aprender Brincando',
            style: TextStyle(
              color: AppConstants.primaryDark,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => Get.back(),
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blue.withValues(alpha: 0.3),
                    style: BorderStyle.solid,
                  ),
                ),
                child: const Icon(Icons.settings_outlined, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'Oi, ${perfil.nome}!',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Text(
                'Pronto para a aventura de hoje?',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 30),
              _buildAvatarSection(atividadeController),
              const SizedBox(height: 40),
              _buildContinueButton(atividadeController),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildSecondaryButton(
                      'Meu Avatar',
                      Icons.checkroom,
                      const Color(0xFFC7EFE5),
                          () => Get.toNamed(AppRoutes.criancaAvatar),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildSecondaryButton(
                      'Prêmios',
                      Icons.stars,
                      const Color(0xFFD4C385),
                          () => Get.toNamed(AppRoutes.criancaPremios),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              _buildProgressSection(atividadeController),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNav(),
      );
    });
  }

  Widget _buildAvatarSection(AtividadeController controller) {
    final proximoNivel = controller.proximoNivelDisponivel;
    final status = proximoNivel > 3
        ? 'Jornada completa'
        : 'Nível $proximoNivel';

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.blue.withValues(alpha: 0.2),
                Colors.blue.withValues(alpha: 0.05),
                Colors.transparent,
              ],
            ),
          ),
          child: const Center(child: AvatarLayeredDisplay(size: 180)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFEED7A1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton(AtividadeController controller) {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF34677E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.iniciarProximoBloco(),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: Text(
                    'Continuar\nJornada',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(
      String label,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.black54, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF2D5A58),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(AtividadeController controller) {
    return Obx(() {
      double progress = (controller.blocosConcluidos.length / 3);
      String percent = "${(progress * 100).toInt()}%";

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Progresso da Jornada',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  percent,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF34677E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: const Color(0xFFE0E0E0),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF2D5A58),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                    (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Icon(
                    index < controller.blocosConcluidos.length
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home, 'Início', true),
          _buildNavItem(Icons.route_outlined, 'Jornada', false),
          _buildNavItem(Icons.stars_outlined, 'Prêmios', false),
          // Removido o item "Perfil" que levava ao relatório
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return InkWell(
      onTap: () {
        if (label == 'Jornada') {
          Get.toNamed(AppRoutes.criancaAtividades);
        } else if (label == 'Prêmios') {
          Get.toNamed(AppRoutes.criancaPremios);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? const Color(0xFF34677E) : Colors.grey),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF34677E) : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
