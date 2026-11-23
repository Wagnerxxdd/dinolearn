class PreferenciaSensorial {
  final int? id;
  final int idPerfil;
  final String corPreferida;
  final bool somAtivado;
  final String velocidadeAnimacao;

  PreferenciaSensorial({
    this.id,
    required this.idPerfil,
    required this.corPreferida,
    required this.somAtivado,
    required this.velocidadeAnimacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_preferencia': id,
      'id_perfil': idPerfil,
      'cor_preferida': corPreferida,
      'som_ativado': somAtivado ? 1 : 0,
      'velocidade_animacao': velocidadeAnimacao,
    };
  }

  factory PreferenciaSensorial.fromMap(Map<String, dynamic> map) {
    return PreferenciaSensorial(
      id: map['id_preferencia'] as int?,
      idPerfil: map['id_perfil'] as int,
      corPreferida: map['cor_preferida'] as String,
      somAtivado: map['som_ativado'] == 1,
      velocidadeAnimacao: map['velocidade_animacao'] as String,
    );
  }

  PreferenciaSensorial copyWith({
    int? id,
    int? idPerfil,
    String? corPreferida,
    bool? somAtivado,
    String? velocidadeAnimacao,
  }) {
    return PreferenciaSensorial(
      id: id ?? this.id,
      idPerfil: idPerfil ?? this.idPerfil,
      corPreferida: corPreferida ?? this.corPreferida,
      somAtivado: somAtivado ?? this.somAtivado,
      velocidadeAnimacao: velocidadeAnimacao ?? this.velocidadeAnimacao,
    );
  }
}
