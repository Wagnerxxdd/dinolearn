import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class ResumoJornadaView extends StatelessWidget {
  const ResumoJornadaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Jornada concluída!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D5A58),
                ),
              ),
              const SizedBox(height: 30),

              _buildCheckItem("Bloco de nível 1"),
              _buildCheckItem("Bloco de nível 2"),
              _buildCheckItem("Bloco de nível 3"),

              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.star, size: 50, color: Colors.amber),
                  SizedBox(width: 8),
                  Icon(Icons.star, size: 50, color: Colors.amber),
                  SizedBox(width: 8),
                  Icon(Icons.star, size: 50, color: Colors.amber),
                ],
              ),

              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.card_giftcard, color: Colors.pinkAccent),
                  SizedBox(width: 8),
                  Text(
                    "Uma recompensa desbloqueada",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () => Get.toNamed(AppRoutes.criancaAvatar),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC7EFE5),
                  minimumSize: const Size(double.infinity, 64),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Ver meu avatar",
                  style: TextStyle(
                    color: Color(0xFF2D5A58),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Get.offAllNamed(AppRoutes.criancaDashboard),
                child: const Text(
                  "Voltar ao painel",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 22),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(fontSize: 18, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
