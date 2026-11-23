class PerfilDificuldade {
  final int? id;
  final int idPerfil;
  final int idDificuldade;
  final int prioridade;

  PerfilDificuldade({
    this.id,
    required this.idPerfil,
    required this.idDificuldade,
    required this.prioridade,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_perfil_dificuldade': id,
      'id_perfil': idPerfil,
      'id_dificuldade': idDificuldade,
      'prioridade': prioridade,
    };
  }

  factory PerfilDificuldade.fromMap(Map<String, dynamic> map) {
    return PerfilDificuldade(
      id: map['id_perfil_dificuldade'] as int?,
      idPerfil: map['id_perfil'] as int,
      idDificuldade: map['id_dificuldade'] as int,
      prioridade: map['prioridade'] as int,
    );
  }
}
