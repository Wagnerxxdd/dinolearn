import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_constants.dart';
import '../../controllers/atividade_controller.dart';

class BlocoIntroView extends StatelessWidget {
  const BlocoIntroView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AtividadeController>();
    final info = _getThemeInfo(controller.nivelAtual.value);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Nível ${controller.nivelAtual.value}",
                style: TextStyle(
                  color: AppConstants.primaryDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                info['titulo']!,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.teal.shade100, width: 4),
                ),
                child: Icon(
                  info['icon'] as IconData,
                  size: 80,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                info['mensagem']!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: controller.proximaAtividadeNoBloco,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryDark,
                  minimumSize: const Size(250, 64),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Começar Aventura!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
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

  Map<String, dynamic> _getThemeInfo(int nivel) {
    if (nivel == 1) {
      return {
        'titulo': 'Mundo dos Dinossauros',
        'mensagem': '“Nova aventura! Vamos conhecer o mundo dos dinossauros.”',
        'icon': Icons.pets,
      };
    }
    if (nivel == 2) {
      return {
        'titulo': 'Aventura das Capivaras',
        'mensagem':
            '“Hoje vamos acompanhar as capivaras em uma aventura perto do rio.”',
        'icon': Icons.water,
      };
    }
    return {
      'titulo': 'O Mundo dos Axolotes',
      'mensagem':
          '“Vamos conhecer os axolotes e explorar um aquário cheio de cores.”',
      'icon': Icons.waves,
    };
  }
}
