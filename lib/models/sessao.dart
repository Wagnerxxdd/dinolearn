class Sessao {
  final int? id;
  final int idPerfil;
  final DateTime dataInicio;
  final DateTime? dataFim;
  final int pontuacao;

  Sessao({
    this.id,
    required this.idPerfil,
    DateTime? dataInicio,
    this.dataFim,
    this.pontuacao = 0,
  }) : dataInicio = dataInicio ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id_sessao': id,
      'id_perfil': idPerfil,
      'data_inicio': dataInicio.toIso8601String(),
      'data_fim': dataFim?.toIso8601String(),
      'pontuacao': pontuacao,
    };
  }

  factory Sessao.fromMap(Map<String, dynamic> map) {
    return Sessao(
      id: map['id_sessao'],
      idPerfil: map['id_perfil'],
      dataInicio: DateTime.parse(map['data_inicio']),
      dataFim: map['data_fim'] != null ? DateTime.parse(map['data_fim']) : null,
      pontuacao: map['pontuacao'],
    );
  }
}
