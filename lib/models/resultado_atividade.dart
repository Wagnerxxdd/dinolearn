class ResultadoAtividade {
  final int? id;
  final int idSessao;
  final int idAtividade;
  final bool acertou;
  final int tentativas;
  final int tempoGastoSegundos;
  final int pontuacaoObtida;
  final DateTime dataExecucao;

  ResultadoAtividade({
    this.id,
    required this.idSessao,
    required this.idAtividade,
    required this.acertou,
    required this.tentativas,
    required this.tempoGastoSegundos,
    required this.pontuacaoObtida,
    DateTime? dataExecucao,
  }) : dataExecucao = dataExecucao ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id_resultado': id,
      'id_sessao': idSessao,
      'id_atividade': idAtividade,
      'acertou': acertou ? 1 : 0,
      'tentativas': tentativas,
      'tempo_gasto_segundos': tempoGastoSegundos,
      'pontuacao_obtida': pontuacaoObtida,
      'data_execucao': dataExecucao.toIso8601String(),
    };
  }

  factory ResultadoAtividade.fromMap(Map<String, dynamic> map) {
    return ResultadoAtividade(
      id: map['id_resultado'],
      idSessao: map['id_sessao'],
      idAtividade: map['id_atividade'],
      acertou: map['acertou'] == 1,
      tentativas: map['tentativas'],
      tempoGastoSegundos: map['tempo_gasto_segundos'],
      pontuacaoObtida: map['pontuacao_obtida'],
      dataExecucao: DateTime.parse(map['data_execucao']),
    );
  }
}
