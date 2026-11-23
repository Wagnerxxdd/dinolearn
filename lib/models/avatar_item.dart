class AvatarItem {
  final int? id;
  final int idPerfil;
  final int idItemAvatar;
  final bool equipado;

  AvatarItem({this.id, required this.idPerfil, required this.idItemAvatar, required this.equipado});

  Map<String, dynamic> toMap() {
    return {
      'id_avatar_item': id,
      'id_perfil': idPerfil,
      'id_item_avatar': idItemAvatar,
      'equipado': equipado ? 1 : 0,
    };
  }

  factory AvatarItem.fromMap(Map<String, dynamic> map) {
    return AvatarItem(
      id: map['id_avatar_item'],
      idPerfil: map['id_perfil'],
      idItemAvatar: map['id_item_avatar'],
      equipado: map['equipado'] == 1,
    );
  }
}
