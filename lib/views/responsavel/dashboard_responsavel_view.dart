import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/perfil_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_constants.dart';
import 'widgets/resumo_progresso_widget.dart';

class DashboardResponsavelView extends StatelessWidget {
  const DashboardResponsavelView({super.key});

  @override
  Widget build(BuildContext context) {
    final PerfilController controller = Get.find<PerfilController>();
    
    return Scaffold(
      backgroundColor: AppConstants.backgroundLight,
      appBar: AppBar(
        title: const Text('Gerenciamento de Perfis', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppConstants.primaryDark,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => controller.prepararNovoPerfil(),
            icon: const Icon(Icons.person_add_alt_1),
            tooltip: 'Criar novo perfil',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            _buildHeader(),
            
            if (controller.perfis.isEmpty)
              _buildEmptyState(controller)
            else
              // Lista de perfis injetada diretamente no scroll
              ...controller.perfis.map((perfil) => _buildPerfilItem(perfil, controller)).toList(),

            const SizedBox(height: 20),
            // O resumo agora rola junto com a lista
            const ResumoProgressoWidget(),
            const SizedBox(height: 100), // Espaço extra para não ficar atrás do botão fixo
          ],
        );
      }),
      // O botão de ação principal fica fixo no rodapé, resolvendo o overflow
      bottomNavigationBar: _buildFixedFooter(controller),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text('Seus Perfis', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text('Gerencie e acompanhe cada criança.', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildPerfilItem(dynamic perfil, PerfilController controller) {
    final bool isSelected = controller.perfilSelecionado.value?.id == perfil.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isSelected 
            ? Border.all(color: AppConstants.primaryDark, width: 2)
            : Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: const Color(0xFFF0F4F8),
          child: Text(perfil.nome[0].toUpperCase(), 
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppConstants.primaryDark)),
        ),
        title: Text(perfil.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${perfil.idade} anos'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
              onPressed: () {
                controller.selecionarPerfil(perfil);
                Get.toNamed(AppRoutes.editarPerfil);
              },
            ),
            IconButton(
              icon: const Icon(Icons.analytics_outlined, color: Colors.teal, size: 20),
              onPressed: () {
                controller.selecionarPerfil(perfil);
                Get.toNamed(AppRoutes.relatorioCrianca);
              },
            ),
          ],
        ),
        onTap: () => controller.selecionarPerfil(perfil),
      ),
    );
  }

  Widget _buildEmptyState(PerfilController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(Icons.child_care, size: 64, color: Colors.grey.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          const Text('Nenhum perfil cadastrado.', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildFixedFooter(PerfilController controller) {
    return Obx(() {
      final perfil = controller.perfilSelecionado.value;
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4))],
        ),
        child: ElevatedButton(
          onPressed: perfil != null 
              ? () => Get.toNamed(AppRoutes.criancaDashboard) 
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF34677E),
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Text(
            perfil != null ? 'Entrar com ${perfil.nome}' : 'Selecione um Perfil',
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    });
  }
}
