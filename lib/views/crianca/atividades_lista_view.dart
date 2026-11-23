import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/atividade_controller.dart';
import '../../utils/app_constants.dart';

class AtividadesListaView extends StatelessWidget {
  const AtividadesListaView({super.key});

  @override
  Widget build(BuildContext context) {
    final AtividadeController controller = Get.find<AtividadeController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: const Text(
          'Minha Jornada',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppConstants.primaryDark,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.atividades.isEmpty) {
          return const Center(
            child: Text('Nenhuma atividade disponível no momento.'),
          );
        }

        final blocos = [1, 2, 3];

        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 12, 24, 8),
              child: Text(
                'Os blocos são apresentados em ordem para deixar a aventura simples e previsível.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: blocos.length,
                itemBuilder: (context, index) {
                  final nivel = blocos[index];
                  final info = _getBlocoInfo(nivel);
                  final isCompleted = controller.blocosConcluidos.contains(
                    nivel,
                  );
                  final isCurrent = nivel == controller.proximoNivelDisponivel;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    color: isCompleted || isCurrent
                        ? Colors.white
                        : Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: isCurrent
                          ? const BorderSide(
                        color: AppConstants.primaryDark,
                        width: 2,
                      )
                          : BorderSide.none,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: (info['color'] as Color).withValues(
                          alpha: 0.12,
                        ),
                        child: Icon(
                          isCompleted
                              ? Icons.check
                              : isCurrent
                              ? info['icon'] as IconData
                              : Icons.lock,
                          color: isCompleted
                              ? Colors.green
                              : isCurrent
                              ? info['color'] as Color
                              : Colors.grey,
                        ),
                      ),
                      title: Text(
                        info['titulo'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isCompleted || isCurrent
                              ? Colors.black87
                              : Colors.grey,
                        ),
                      ),
                      subtitle: Text(
                        isCompleted
                            ? 'Concluído • 1 estrela'
                            : isCurrent
                            ? 'Próximo bloco • 3 atividades'
                            : 'Conclua o bloco anterior',
                      ),
                    ),
                  );
                },
              ),
            ),
            SafeArea(
              minimum: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: ElevatedButton.icon(
                onPressed: controller.iniciarProximoBloco,
                icon: Icon(
                  controller.proximoNivelDisponivel > 3
                      ? Icons.emoji_events
                      : Icons.play_arrow,
                ),
                label: Text(
                  controller.proximoNivelDisponivel > 3
                      ? 'Ver jornada concluída'
                      : 'Continuar jornada',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryDark,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Map<String, dynamic> _getBlocoInfo(int nivel) {
    if (nivel == 1) {
      return {
        'titulo': 'Mundo dos Dinossauros',
        'icon': Icons.pets,
        'color': Colors.green,
      };
    }
    if (nivel == 2) {
      return {
        'titulo': 'Aventura das Capivaras',
        'icon': Icons.water,
        'color': Colors.blue,
      };
    }
    return {
      'titulo': 'O Mundo dos Axolotes',
      'icon': Icons.waves,
      'color': Colors.purple,
    };
  }
}
