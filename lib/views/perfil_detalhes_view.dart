import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/perfil_controller.dart';
import '../routes/app_routes.dart';
import '../utils/app_constants.dart';

class PerfilDetalhesView extends StatelessWidget {
  const PerfilDetalhesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PerfilController controller = Get.find<PerfilController>();

    return Scaffold(
      backgroundColor: AppConstants.backgroundLight,
      appBar: AppBar(
        title: const Text('Detalhes do Perfil'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppConstants.primaryDark,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _showDeleteConfirmation(controller),
          ),
        ],
      ),
      body: Obx(() {
        final perfil = controller.perfilSelecionado.value;
        if (perfil == null) return const Center(child: Text('Nenhum perfil selecionado'));

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Avatar centralizado com as novas cores do banco
              CircleAvatar(
                radius: 60,
                backgroundColor: AppConstants.coresSuaves[perfil.corPreferida] ?? Colors.blue.shade50,
                child: Text(
                  perfil.nome.isNotEmpty ? perfil.nome[0].toUpperCase() : '?',
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppConstants.primaryDark),
                ),
              ),
              const SizedBox(height: 16),
              Text(perfil.nome, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              Text('${perfil.idade} anos', style: const TextStyle(fontSize: 18, color: Colors.black54)),
              const SizedBox(height: 32),
              
              _buildInfoSection(
                title: 'Preferências Sensoriais',
                children: [
                  _buildInfoTile(Icons.palette, 'Cor Preferida', perfil.corPreferida ?? 'Não definida'),
                  _buildInfoTile(Icons.volume_up, 'Efeitos de Som', (perfil.somAtivado ?? true) ? 'Ativados' : 'Desativados'),
                  _buildInfoTile(Icons.speed, 'Velocidade', '${perfil.velocidadeAnimacao ?? '1.0'}x'),
                ],
              ),
              const SizedBox(height: 16),
              
              _buildInfoSection(
                title: 'Foco de Aprendizado',
                children: [
                  if (perfil.focosAprendizado.isEmpty)
                    const Text('Nenhum foco selecionado', style: TextStyle(color: Colors.black38))
                  else
                    Wrap(
                      spacing: 8,
                      children: perfil.focosAprendizado.map((f) => Chip(
                        label: Text(f),
                        backgroundColor: Colors.teal.shade50,
                      )).toList(),
                    ),
                ],
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.editarPerfil),
        backgroundColor: AppConstants.primaryDark,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildInfoSection({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppConstants.primaryDark)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppConstants.primaryDark, size: 20),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(PerfilController controller) {
    final perfil = controller.perfilSelecionado.value;
    if (perfil == null) return;
    Get.dialog(
      AlertDialog(
        title: const Text('Confirmar Deleção'),
        content: Text('Deseja deletar o perfil de ${perfil.nome}? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              controller.deletarPerfil(perfil.id!, perfil.nome);
              Get.back();
              Get.back();
            },
            child: const Text('Deletar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
