import 'package:flutter/material.dart';

/// Constantes da aplicação
class AppConstants {
  // Cores suaves da imagem
  static const Map<String, Color> coresSuaves = {
    'Azul Bebê': Color(0xFFE3F2FD),
    'Lavanda': Color(0xFFF3E5F5),
    'Verde Menta': Color(0xFFE8F5E9),
    'Creme': Color(0xFFFFFDE7),
    'Turquesa Suave': Color(0xFFE0F2F1),
  };

  // Focos de aprendizado
  static const List<String> focosAprendizado = [
    'Matemática',
    'Português',
    'Emoções',
    'Cotidiano',
  ];

  // Configurações
  static const double velocidadePadrao = 1.0;
  static const int idadeMinima = 3;
  static const int idadeMaxima = 18;

  // Estilo de Cores (Paleta baseada na imagem)
  static const Color primaryDark = Color(0xFF2D5A58); // Cor do botão "Painel do Responsável"
  static const Color backgroundLight = Color(0xFFF8FAFB);
  static const Color cardShadow = Color(0x1A000000);
}
