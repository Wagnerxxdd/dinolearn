import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/perfil_controller.dart';
import '../../controllers/relatorio_controller.dart';
import '../../utils/app_constants.dart';
import '../crianca/widgets/avatar_layered_display.dart';

class RelatorioCriancaView extends StatelessWidget {
  const RelatorioCriancaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final perfilCtrl = Get.find<PerfilController>();
    final relCtrl = Get.find<RelatorioController>();
    final perfil = perfilCtrl.perfilSelecionado.value;

    return Scaffold(
      backgroundColor: AppConstants.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Relatório de Atividades',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppConstants.primaryDark,
        centerTitle: true,
      ),
      body: Obx(() {
        if (perfil == null)
          return const Center(
            child: Text('Selecione um perfil para visualizar o relatório.'),
          );
        if (relCtrl.isLoading.value)
          return const Center(child: CircularProgressIndicator());

        final rel = relCtrl.relatorioConsolidado.value;
        final res = relCtrl.resumoAtivo.value;

        if (rel == null || rel.totalTentativas == 0) {
          return _buildEmptyRelatorio(perfil.nome);
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(perfil.nome),
              const SizedBox(height: 30),

              const Text(
                'Resumo da jornada',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildJornadaGrid(res!),

              const SizedBox(height: 32),
              const Text(
                'Resumo da execução',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildExecucaoResumo(rel),

              const SizedBox(height: 32),
              const Text(
                'Resumo por bloco',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...rel.blocos.map((b) => _buildBlocoCard(b)).toList(),

              const SizedBox(height: 32),
              const Text(
                'Resumo por área',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...rel.areas.map((a) => _buildAreaCard(a)).toList(),

              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader(String nome) {
    return Center(
      child: Column(
        children: [
          const AvatarLayeredDisplay(size: 100),
          const SizedBox(height: 12),
          Text(
            'Perfil: $nome',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyRelatorio(String nome) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Relatório: $nome',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            const Icon(Icons.history_toggle_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Nenhuma atividade foi realizada até o momento.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJornadaGrid(dynamic res) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildRowInfo('Blocos concluídos', '${res.blocosConcluidos} de 3'),
          const Divider(),
          _buildRowInfo(
            'Atividades concluídas',
            '${res.atividadesConcluidas} de 9',
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Estrelas', style: TextStyle(color: Colors.black54)),
              Row(
                children: List.generate(
                  3,
                  (i) => Icon(
                    i < res.estrelas ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          _buildRowInfo(
            'Boné Dino',
            res.recompensaDesbloqueada ? 'Desbloqueado ✓' : 'Bloqueado 🔒',
          ),
        ],
      ),
    );
  }

  Widget _buildExecucaoResumo(dynamic rel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D5A58),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildDarkRow(
            'Tentativas realizadas',
            rel.totalTentativas.toString(),
          ),
          _buildDarkRow('Respostas incorretas', rel.totalErros.toString()),
          _buildDarkRow('Dicas utilizadas', rel.totalDicas.toString()),
          if (rel.tempoTotalSegundos > 0)
            _buildDarkRow(
              'Tempo registrado',
              _formatTempo(rel.tempoTotalSegundos),
            ),
        ],
      ),
    );
  }

  Widget _buildBlocoCard(dynamic b) {
    if (b.tentativas == 0) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bloco ${b.nivel} — ${b.tema}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              '${b.concluidas}/3 atividades concluídas ${b.concluido ? "⭐ Concluído" : ""}',
              style: TextStyle(
                color: b.concluido ? Colors.green : Colors.orange,
                fontSize: 13,
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSmallMetric('Tentativas', b.tentativas.toString()),
                _buildSmallMetric('Erros', b.erros.toString()),
                _buildSmallMetric('Dicas', b.dicas.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaCard(dynamic a) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.teal.shade50,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        title: Text(
          a.area,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${a.concluidas} de 3 atividades concluídas\nTentativas: ${a.tentativas} • Dicas: ${a.dicas}',
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildRowInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDarkRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallMetric(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  String _formatTempo(int seg) {
    int min = seg ~/ 60;
    int s = seg % 60;
    return min > 0 ? '${min} min ${s} s' : '${s} s';
  }
}
