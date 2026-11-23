class Responsavel {
  final int? id;
  final String nome;
  final String email;
  final String senhaHash;
  final DateTime dataCriacao;

  Responsavel({
    this.id,
    required this.nome,
    required this.email,
    required this.senhaHash,
    DateTime? dataCriacao,
  }) : dataCriacao = dataCriacao ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id_responsavel': id,
      'nome': nome,
      'email': email,
      'senha_hash': senhaHash,
      'data_criacao': dataCriacao.toIso8601String(),
    };
  }

  factory Responsavel.fromMap(Map<String, dynamic> map) {
    return Responsavel(
      id: map['id_responsavel'] as int?,
      nome: map['nome'] as String,
      email: map['email'] as String,
      senhaHash: map['senha_hash'] as String,
      dataCriacao: DateTime.parse(map['data_criacao'] as String),
    );
  }

  Responsavel copyWith({
    int? id,
    String? nome,
    String? email,
    String? senhaHash,
    DateTime? dataCriacao,
  }) {
    return Responsavel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      senhaHash: senhaHash ?? this.senhaHash,
      dataCriacao: dataCriacao ?? this.dataCriacao,
    );
  }
}
