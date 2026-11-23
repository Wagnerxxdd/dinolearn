import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/relatorio_controller.dart';
import '../../controllers/perfil_controller.dart';
import '../../utils/app_constants.dart';
import '../../services/relatorio_service.dart';

class AcompanhamentoDetalhadoView extends StatelessWidget {
  const AcompanhamentoDetalhadoView({super.key});

  @override
  Widget build(BuildContext context) {
    final relCtrl = Get.find<RelatorioController>();
    final perfilCtrl = Get.find<PerfilController>();

    return Scaffold(
      backgroundColor: AppConstants.backgroundLight,
      appBar: AppBar(
        title: const Text('Acompanhamento Detalhado', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppConstants.primaryDark,
      ),
      body: Obx(() {
        final perfil = perfilCtrl.perfilSelecionado.value;
        if (perfil == null) {
          return const Center(child: Text('Selecione um perfil para acompanhar o progresso.'));
        }

        if (relCtrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Agrupando atividades por nível/bloco
        Map<int, List<RelatorioAtividadeModel>> blocos = {
          1: relCtrl.detalhes.where((a) => a.nivel == 1).toList(),
          2: relCtrl.detalhes.where((a) => a.nivel == 2).toList(),
          3: relCtrl.detalhes.where((a) => a.nivel == 3).toList(),
        };

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildProfileHeader(perfil.nome),
            const SizedBox(height: 24),
            _buildBlocoTile(1, 'Dinossauros', blocos[1]!),
            const SizedBox(height: 12),
            _buildBlocoTile(2, 'Capivaras', blocos[2]!),
            const SizedBox(height: 12),
            _buildBlocoTile(3, 'Axolotes', blocos[3]!),
            const SizedBox(height: 40),
          ],
        );
      }),
    );
  }

  Widget _buildProfileHeader(String nome) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const CircleAvatar(backgroundColor: Color(0xFFC7EFE5), child: Icon(Icons.person, color: Color(0xFF2D5A58))),
          const SizedBox(width: 12),
          Text('Perfil: $nome', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBlocoTile(int nivel, String tema, List<RelatorioAtividadeModel> atividades) {
    int concluidas = atividades.where((a) => a.concluida).length;
    bool totalConcluido = concluidas == 3;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: totalConcluido ? Colors.green.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.1)),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: totalConcluido ? Colors.green.shade50 : Colors.grey.shade50,
          child: Text(nivel.toString(), style: TextStyle(color: totalConcluido ? Colors.green : Colors.grey, fontWeight: FontWeight.bold)),
        ),
        title: Text('Bloco $nivel — $tema', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$concluidas de 3 atividades concluídas', 
          style: TextStyle(color: totalConcluido ? Colors.green : Colors.orange, fontSize: 13)),
        trailing: Icon(totalConcluido ? Icons.check_circle : Icons.pending, color: totalConcluido ? Colors.green : Colors.orange),
        children: atividades.map((a) => _buildAtividadeDetail(a)).toList(),
      ),
    );
  }

  Widget _buildAtividadeDetail(RelatorioAtividadeModel a) {
    if (!a.concluida && a.tentativas == 0) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(60, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(a.area, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
            Text(a.titulo, style: const TextStyle(color: Colors.grey)),
            const Text('Ainda não realizada', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey)),
            const Divider(),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(60, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(a.area, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
              const Icon(Icons.check_circle_outline, color: Colors.green, size: 16),
            ],
          ),
          Text(a.titulo, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          _buildNeutralMetric('Status: ', 'Concluída ✓'),
          _buildNeutralMetric('Tentativas: ', a.tentativas.toString()),
          _buildNeutralMetric('Respostas incorretas: ', a.erros.toString()),
          _buildNeutralMetric('Dicas utilizadas: ', a.dicas.toString()),
          _buildNeutralMetric('Tempo: ', _formatTempo(a.tempoSegundos)),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildNeutralMetric(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 13),
          children: [
            TextSpan(text: label, style: const TextStyle(color: Colors.black54)),
            TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  String _formatTempo(int seg) {
    if (seg < 60) return '${seg}s';
    int min = seg ~/ 60;
    int s = seg % 60;
    return '${min}m ${s}s';
  }
}
