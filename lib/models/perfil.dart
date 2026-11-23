class Perfil {
  final int? id;
  final int idResponsavel;
  final int idAvatar;
  final String nome;
  final int idade;
  final DateTime dataCriacao;
  
  final String? corPreferida;
  final bool? somAtivado;
  final String? velocidadeAnimacao;
  final List<String> focosAprendizado;

  Perfil({
    this.id,
    required this.idResponsavel,
    required this.idAvatar,
    required this.nome,
    required this.idade,
    DateTime? dataCriacao,
    this.corPreferida,
    this.somAtivado,
    this.velocidadeAnimacao,
    this.focosAprendizado = const [],
  }) : dataCriacao = dataCriacao ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id_perfil': id,
      'id_responsavel': idResponsavel,
      'id_avatar': idAvatar,
      'nome': nome,
      'idade': idade,
      'data_criacao': dataCriacao.toIso8601String(),
    };
  }

  factory Perfil.fromMap(Map<String, dynamic> map) {
    return Perfil(
      // Forçamos a conversão para int para evitar erros de tipagem do SQLite
      id: map['id_perfil'] != null ? int.parse(map['id_perfil'].toString()) : null,
      idResponsavel: int.parse(map['id_responsavel'].toString()),
      idAvatar: int.parse(map['id_avatar'].toString()),
      nome: map['nome'] as String,
      idade: int.parse(map['idade'].toString()),
      dataCriacao: DateTime.parse(map['data_criacao'] as String),
      corPreferida: map['cor_preferida'] as String?,
      somAtivado: map['som_ativado'] != null ? map['som_ativado'] == 1 : null,
      velocidadeAnimacao: map['velocidade_animacao']?.toString(),
      focosAprendizado: [],
    );
  }

  Perfil copyWith({
    int? id,
    int? idResponsavel,
    int? idAvatar,
    String? nome,
    int? idade,
    DateTime? dataCriacao,
    String? corPreferida,
    bool? somAtivado,
    String? velocidadeAnimacao,
    List<String>? focosAprendizado,
  }) {
    return Perfil(
      id: id ?? this.id,
      idResponsavel: idResponsavel ?? this.idResponsavel,
      idAvatar: idAvatar ?? this.idAvatar,
      nome: nome ?? this.nome,
      idade: idade ?? this.idade,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      corPreferida: corPreferida ?? this.corPreferida,
      somAtivado: somAtivado ?? this.somAtivado,
      velocidadeAnimacao: velocidadeAnimacao ?? this.velocidadeAnimacao,
      focosAprendizado: focosAprendizado ?? this.focosAprendizado,
    );
  }
}
