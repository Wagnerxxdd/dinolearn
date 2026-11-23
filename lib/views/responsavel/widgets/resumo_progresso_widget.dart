import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tea_app/controllers/relatorio_controller.dart';
import 'package:tea_app/controllers/perfil_controller.dart';
import 'package:tea_app/utils/app_constants.dart';
import 'package:tea_app/routes/app_routes.dart';
import 'package:tea_app/views/crianca/widgets/avatar_layered_display.dart';

class ResumoProgressoWidget extends StatelessWidget {
  const ResumoProgressoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final relCtrl = Get.find<RelatorioController>();
    final perfilCtrl = Get.find<PerfilController>();

    return Obx(() {
      final perfil = perfilCtrl.perfilSelecionado.value;
      final resumo = relCtrl.resumoAtivo.value;

      if (perfil == null) {
        return _buildEmptyState();
      }

      if (relCtrl.isLoading.value) {
        return const Center(child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ));
      }

      return Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Resumo do progresso', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              children: [
                const AvatarLayeredDisplay(size: 60),
                const SizedBox(width: 16),
                Text(perfil.nome, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 24),
            _buildInfoCard('Jornada', '${resumo?.blocosConcluidos ?? 0} de 3 blocos concluídos', Icons.auto_awesome_motion),
            const SizedBox(height: 12),
            _buildInfoCard('Atividades', '${resumo?.atividadesConcluidas ?? 0} de 9 concluídas', Icons.school),
            const SizedBox(height: 12),
            _buildStarsRow(resumo?.estrelas ?? 0),
            const SizedBox(height: 12),
            _buildRewardCard(resumo?.recompensaDesbloqueada ?? false),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Get.toNamed(AppRoutes.acompanhamentoDetalhado),
                    icon: const Icon(Icons.list_alt),
                    label: const Text('Acompanhar'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Get.toNamed(AppRoutes.personalizarInterface),
                    icon: const Icon(Icons.tune),
                    label: const Text('Configurar'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.relatorioCrianca),
              icon: const Icon(Icons.analytics_outlined),
              label: const Text('Ver relatório consolidado'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryDark,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      child: const Text(
        'Selecione um perfil para visualizar o progresso.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Icon(icon, color: AppConstants.primaryDark, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStarsRow(int count) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Estrelas', style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: List.generate(3, (i) => Icon(
              i < count ? Icons.star : Icons.star_border,
              color: Colors.amber,
              size: 24,
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard(bool unlocked) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: unlocked ? Colors.teal.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.card_giftcard, color: unlocked ? Colors.teal : Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Recompensa: Boné de dinossauro', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                Text(unlocked ? 'Desbloqueado' : 'Bloqueado', 
                  style: TextStyle(fontSize: 12, color: unlocked ? Colors.teal : Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
