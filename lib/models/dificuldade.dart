class Dificuldade {
  final int? id;
  final String nome;
  final String? descricao;

  Dificuldade({
    this.id,
    required this.nome,
    this.descricao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_dificuldade': id,
      'nome': nome,
      'descricao': descricao,
    };
  }

  factory Dificuldade.fromMap(Map<String, dynamic> map) {
    return Dificuldade(
      id: map['id_dificuldade'] as int?,
      nome: map['nome'] as String,
      descricao: map['descricao'] as String?,
    );
  }
}
