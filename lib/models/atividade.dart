class Atividade {
  final int? id;
  final int idDificuldade;
  final String titulo;
  final String descricao;
  final String tipo;
  final int nivel;
  final String caminhoJson;
  final bool ativa;

  Atividade({
    this.id,
    required this.idDificuldade,
    required this.titulo,
    required this.descricao,
    required this.tipo,
    required this.nivel,
    required this.caminhoJson,
    required this.ativa,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_atividade': id,
      'id_dificuldade': idDificuldade,
      'titulo': titulo,
      'descricao': descricao,
      'tipo': tipo,
      'nivel': nivel,
      'caminho_json': caminhoJson,
      'ativa': ativa ? 1 : 0,
    };
  }

  factory Atividade.fromMap(Map<String, dynamic> map) {
    return Atividade(
      id: map['id_atividade'],
      idDificuldade: map['id_dificuldade'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      tipo: map['tipo'],
      nivel: map['nivel'],
      caminhoJson: map['caminho_json'],
      ativa: map['ativa'] == 1,
    );
  }
}
