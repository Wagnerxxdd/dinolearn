import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_constants.dart';
import '../../routes/app_routes.dart';
import '../../controllers/atividade_controller.dart';

class BlocoConclusaoView extends StatelessWidget {
  const BlocoConclusaoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AtividadeController>();
    final blocosConcluidos = controller.blocosConcluidos.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Muito bem! 🎉",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D5A58),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _mensagemConclusao(controller.nivelAtual.value),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const SizedBox(height: 30),

              // Exibição do Progresso em Estrelas
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStar(blocosConcluidos >= 1),
                  const SizedBox(width: 10),
                  _buildStar(blocosConcluidos >= 2),
                  const SizedBox(width: 10),
                  _buildStar(blocosConcluidos >= 3),
                ],
              ),

              const SizedBox(height: 30),
              const Text(
                "⭐ Você ganhou uma estrela!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),

              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  if (blocosConcluidos >= 3) {
                    Get.offNamed(AppRoutes.criancaRecompensa);
                  } else {
                    Get.offAllNamed(AppRoutes.criancaDashboard);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryDark,
                  minimumSize: const Size(double.infinity, 64),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  blocosConcluidos >= 3
                      ? "Ver minha recompensa!"
                      : "Continuar Jornada",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStar(bool filled) {
    return Icon(
      filled ? Icons.star : Icons.star_border,
      size: 70,
      color: filled ? Colors.amber : Colors.grey.shade300,
    );
  }

  String _mensagemConclusao(int nivel) {
    if (nivel == 1) {
      return 'Você terminou a aventura dos dinossauros e ganhou uma estrela!';
    }
    if (nivel == 2) {
      return 'Você ajudou as capivaras e ganhou mais uma estrela!';
    }
    return 'Você completou as três aventuras e ganhou a terceira estrela!';
  }
}
