class Avatar {
  final int? id;
  final String nome;
  final String imagemBase;

  Avatar({this.id, required this.nome, required this.imagemBase});

  Map<String, dynamic> toMap() {
    return {
      'id_avatar': id,
      'nome': nome,
      'imagem_base': imagemBase,
    };
  }

  factory Avatar.fromMap(Map<String, dynamic> map) {
    return Avatar(
      id: map['id_avatar'],
      nome: map['nome'],
      imagemBase: map['imagem_base'],
    );
  }
}
