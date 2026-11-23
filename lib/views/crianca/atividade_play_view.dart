import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/atividade_controller.dart';
import '../../models/atividade_conteudo.dart';

class AtividadePlayView extends StatefulWidget {
  const AtividadePlayView({Key? key}) : super(key: key);

  @override
  State<AtividadePlayView> createState() => _AtividadePlayViewState();
}

class _AtividadePlayViewState extends State<AtividadePlayView> {
  List<String> palavrasOrdenadas = [];
  bool isChecking = false;

  void _checkAnswer(String selectedId, String correctId, AtividadeConteudo conteudo, AtividadeController controller) async {
    if (isChecking) return;
    setState(() => isChecking = true);

    if (selectedId == correctId) {
      await controller.registrarSucesso();
      if (mounted) _showSuccessDialog(controller);
    } else {
      _handleError(conteudo, controller);
      setState(() => isChecking = false);
    }
  }

  void _handleError(AtividadeConteudo conteudo, AtividadeController controller) {
    controller.registrarErro();
    
    String msgIncentivo = "Tente de novo, você consegue! 💪";
    String? dica;
    
    if (controller.tentativasAtuais.value == 2) {
      dica = conteudo.dicaErro1;
    } else if (controller.tentativasAtuais.value >= 3) {
      dica = conteudo.apoioErro2;
    }

    Get.snackbar(
      'Quase lá! ✨',
      dica ?? msgIncentivo,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange.shade100,
      colorText: Colors.orange.shade900,
    );
  }

  void _showSuccessDialog(AtividadeController controller) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Column(
          children: const [
            Icon(Icons.stars, color: Colors.amber, size: 48),
            SizedBox(height: 8),
            Text('Muito bem! 🎉', textAlign: TextAlign.center),
          ],
        ),
        content: const Text('Você completou a missão!', textAlign: TextAlign.center),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Get.back(); // fecha dialog
                setState(() => isChecking = false);
                controller.proximaAtividadeNoBloco();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: const StadiumBorder(),
              ),
              child: const Text('Continuar', style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AtividadeController controller = Get.find<AtividadeController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.grey),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final conteudo = controller.conteudoAtual.value;
        final tentativas = controller.tentativasAtuais.value;
        
        if (conteudo == null) return const Center(child: CircularProgressIndicator());

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              _buildQuestionHeader(conteudo.pergunta),
              const SizedBox(height: 15),
              
              if (tentativas > 1) _buildDicaCard(conteudo, tentativas),
              
              const SizedBox(height: 15),
              
              if (conteudo.tipo == 'ordenacao')
                _buildOrdenacaoUI(conteudo, controller)
              else ...[
                _buildVisualSupport(conteudo, tentativas),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: conteudo.alternativas.length,
                    itemBuilder: (context, index) {
                      final alt = conteudo.alternativas[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildOptionButton(alt.texto, () {
                          _checkAnswer(alt.id, conteudo.respostaCorreta, conteudo, controller);
                        }),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildVisualSupport(AtividadeConteudo conteudo, int tentativas) {
    double height = tentativas >= 3 ? 200 : 160;
    if (conteudo.imagem == null) return const SizedBox.shrink();

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: tentativas >= 3 ? Colors.orange.shade200 : Colors.white, 
          width: 6,
        ),
        boxShadow: tentativas >= 3 ? [BoxShadow(color: Colors.orange.withOpacity(0.1), blurRadius: 20)] : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          conteudo.imagem!, 
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 60, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildOrdenacaoUI(AtividadeConteudo conteudo, AtividadeController controller) {
    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 60),
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade100),
          ),
          child: Text(
            palavrasOrdenadas.join(' '),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: conteudo.alternativas.map((alt) {
            bool jaUsada = palavrasOrdenadas.contains(alt.texto);
            return FilterChip(
              label: Text(alt.texto),
              onSelected: jaUsada || isChecking ? null : (selected) {
                setState(() {
                  palavrasOrdenadas.add(alt.texto);
                  if (palavrasOrdenadas.length == conteudo.alternativas.length) {
                    String fraseMontada = palavrasOrdenadas.join(' ');
                    _checkAnswer(fraseMontada, conteudo.respostaCorreta, conteudo, controller);
                    if (fraseMontada != conteudo.respostaCorreta) {
                       palavrasOrdenadas.clear();
                    }
                  }
                });
              },
            );
          }).toList(),
        ),
        TextButton(onPressed: isChecking ? null : () => setState(() => palavrasOrdenadas.clear()), child: const Text('Limpar'))
      ],
    );
  }

  Widget _buildDicaCard(AtividadeConteudo conteudo, int tentativas) {
    String? dica = tentativas == 2 ? conteudo.dicaErro1 : conteudo.apoioErro2;
    if (dica == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(child: Text(dica, style: const TextStyle(color: Colors.orange, fontSize: 13, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildQuestionHeader(String pergunta) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10)],
      ),
      child: Text(
        pergunta,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildOptionButton(String text, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: isChecking ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        side: BorderSide(color: Colors.teal.shade50, width: 2),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}
