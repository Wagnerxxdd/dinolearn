class ItemAvatar {
  final int? id;
  final String nome;
  final String categoria;
  final String imagem;

  ItemAvatar({this.id, required this.nome, required this.categoria, required this.imagem});

  Map<String, dynamic> toMap() {
    return {
      'id_item_avatar': id,
      'nome': nome,
      'categoria': categoria,
      'imagem': imagem,
    };
  }

  factory ItemAvatar.fromMap(Map<String, dynamic> map) {
    return ItemAvatar(
      id: map['id_item_avatar'],
      nome: map['nome'],
      categoria: map['categoria'],
      imagem: map['imagem'],
    );
  }
}
