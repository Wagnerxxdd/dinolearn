import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/atividade.dart';
import '../models/atividade_conteudo.dart';
import '../data/repositories/atividade_repository.dart';

class AtividadeService {
  final AtividadeRepository _repository = AtividadeRepository();

  Future<List<Atividade>> getAtividadesAtivas() async {
    final maps = await _repository.getAllAtivas();
    return maps.map((m) => Atividade.fromMap(m)).toList();
  }

  Future<AtividadeConteudo> carregarConteudo(String caminhoJson) async {
    try {
      final String response = await rootBundle.loadString(caminhoJson);
      final data = await json.decode(response);
      return AtividadeConteudo.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao carregar conteúdo da atividade: $e');
    }
  }
}
