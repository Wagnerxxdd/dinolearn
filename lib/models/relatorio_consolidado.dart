class ResumoBlocoConsolidado {
  final int nivel;
  final String tema;
  final int concluidas;
  final int tentativas;
  final int erros;
  final int dicas;
  final bool concluido;

  ResumoBlocoConsolidado({
    required this.nivel,
    required this.tema,
    required this.concluidas,
    required this.tentativas,
    required this.erros,
    required this.dicas,
    required this.concluido,
  });
}

class ResumoAreaConsolidada {
  final String area;
  final int concluidas;
  final int tentativas;
  final int dicas;

  ResumoAreaConsolidada({
    required this.area,
    required this.concluidas,
    required this.tentativas,
    required this.dicas,
  });
}

class RelatorioConsolidado {
  final int totalTentativas;
  final int totalErros;
  final int totalDicas;
  final int tempoTotalSegundos;
  final List<ResumoBlocoConsolidado> blocos;
  final List<ResumoAreaConsolidada> areas;

  RelatorioConsolidado({
    required this.totalTentativas,
    required this.totalErros,
    required this.totalDicas,
    required this.tempoTotalSegundos,
    required this.blocos,
    required this.areas,
  });
}
