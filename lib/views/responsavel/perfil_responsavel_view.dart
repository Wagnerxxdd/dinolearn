import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/responsavel_controller.dart';
import '../../utils/app_constants.dart';
import '../../routes/app_routes.dart';

class PerfilResponsavelView extends StatelessWidget {
  const PerfilResponsavelView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ResponsavelController>();

    return Scaffold(
      backgroundColor: AppConstants.backgroundLight,
      appBar: AppBar(
        title: const Text('Perfil do Responsável', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppConstants.primaryDark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFFC7EFE5),
              child: Icon(Icons.person, size: 50, color: Color(0xFF2D5A58)),
            ),
            const SizedBox(height: 24),
            _buildInfoCard(controller),
            const SizedBox(height: 32),
            _buildActionButtons(context, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(ResponsavelController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.badge_outlined, 'Nome', 'Responsável Local'),
          const Divider(height: 32),
          _buildInfoRow(Icons.email_outlined, 'E-mail', 'local@app.com'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppConstants.primaryDark, size: 24),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, ResponsavelController controller) {
    return Column(
      children: [
        _buildMenuButton(Icons.edit_outlined, 'Editar Nome', () {}),
        _buildMenuButton(Icons.lock_outline, 'Alterar Senha', () {}),
        const SizedBox(height: 24),
        _buildMenuButton(Icons.logout, 'Sair da Conta', () => Get.offAllNamed(AppRoutes.home), isDanger: true),
        _buildMenuButton(Icons.delete_forever_outlined, 'Excluir Conta', () => _confirmExclusao(context), isDanger: true),
      ],
    );
  }

  Widget _buildMenuButton(IconData icon, String label, VoidCallback onTap, {bool isDanger = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        tileColor: isDanger ? Colors.red.shade50 : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        leading: Icon(icon, color: isDanger ? Colors.red : AppConstants.primaryDark),
        title: Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: isDanger ? Colors.red : Colors.black87)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      ),
    );
  }

  void _confirmExclusao(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Excluir Conta?'),
        content: const Text('Todos os dados e perfis das crianças serão perdidos permanentemente.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancelar')),
          TextButton(onPressed: () => Get.offAllNamed(AppRoutes.home), child: const Text('Sim, Excluir', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}
