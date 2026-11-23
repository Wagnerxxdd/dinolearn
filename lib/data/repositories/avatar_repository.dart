import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';
import '../../models/item_avatar.dart';

class AvatarRepository {
  final AppDatabase _db = AppDatabase.instance;

  Future<List<ItemAvatar>> getAllItems() async {
    final db = await _db.database;
    final result = await db.query('item_avatar');
    return result.map((json) => ItemAvatar.fromMap(json)).toList();
  }

  Future<List<ItemAvatar>> getItemsByPerfil(int idPerfil) async {
    final db = await _db.database;
    final result = await db.rawQuery(
      '''
      SELECT i.* FROM item_avatar i
      JOIN avatar_item ai ON i.id_item_avatar = ai.id_item_avatar
      WHERE ai.id_perfil = ?
    ''',
      [idPerfil],
    );
    return result.map((json) => ItemAvatar.fromMap(json)).toList();
  }

  Future<List<ItemAvatar>> getEquippedItems(int idPerfil) async {
    final db = await _db.database;
    final result = await db.rawQuery(
      '''
      SELECT i.* FROM item_avatar i
      JOIN avatar_item ai ON i.id_item_avatar = ai.id_item_avatar
      WHERE ai.id_perfil = ? AND ai.equipado = 1
    ''',
      [idPerfil],
    );
    return result.map((json) => ItemAvatar.fromMap(json)).toList();
  }

  Future<void> toggleEquipItem(
      int idPerfil,
      ItemAvatar item,
      bool shouldEquip,
      ) async {
    final db = await _db.database;
    await db.transaction((txn) async {
      if (shouldEquip) {
        // 1. Desequipar todos da mesma categoria
        await txn.rawUpdate(
          '''
          UPDATE avatar_item SET equipado = 0 
          WHERE id_perfil = ? AND id_item_avatar IN (
            SELECT id_item_avatar FROM item_avatar WHERE categoria = ?
          )
        ''',
          [idPerfil, item.categoria],
        );

        // 2. Equipar este
        await txn.update(
          'avatar_item',
          {'equipado': 1},
          where: 'id_perfil = ? AND id_item_avatar = ?',
          whereArgs: [idPerfil, item.id],
        );
      } else {
        // Desequipar apenas este
        await txn.update(
          'avatar_item',
          {'equipado': 0},
          where: 'id_perfil = ? AND id_item_avatar = ?',
          whereArgs: [idPerfil, item.id],
        );
      }
    });
  }

  Future<void> unlockItem(int idPerfil, int idItemAvatar) async {
    final db = await _db.database;
    // Insere se não existir para garantir que o item esteja no "armário" da criança
    await db.insert('avatar_item', {
      'id_perfil': idPerfil,
      'id_item_avatar': idItemAvatar,
      'equipado': 0,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  /// Aplica a regra atual da jornada aos itens de recompensa.
  ///
  /// Apenas o Bone Dino (item 1) e concedido ao concluir os tres blocos.
  /// A limpeza corrige perfis que receberam os itens 2, 3 e 4 pela regra
  /// antiga, que desbloqueava o kit inteiro indevidamente.
  Future<void> sincronizarRecompensaJornada(
      int idPerfil, {
        required bool jornadaCompleta,
      }) async {
    final db = await _db.database;

    await db.transaction((txn) async {
      await txn.delete(
        'avatar_item',
        where: jornadaCompleta
            ? 'id_perfil = ? AND id_item_avatar IN (2, 3, 4)'
            : 'id_perfil = ? AND id_item_avatar IN (1, 2, 3, 4)',
        whereArgs: [idPerfil],
      );

      if (jornadaCompleta) {
        await txn.insert('recompensa', {
          'id_recompensa': 1,
          'nome': 'Boné de Dinossauro',
          'descricao': 'Item cosmético concedido ao concluir os três blocos.',
          'tipo': 'avatar',
          'imagem': 'assets/images/avatars/bone_dino.png',
        }, conflictAlgorithm: ConflictAlgorithm.ignore);

        await txn.insert('avatar_item', {
          'id_perfil': idPerfil,
          'id_item_avatar': 1,
          'equipado': 0,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);

        await txn.insert('perfil_recompensa', {
          'id_perfil': idPerfil,
          'id_recompensa': 1,
          'data_desbloqueio': DateTime.now().toIso8601String(),
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      } else {
        await txn.delete(
          'perfil_recompensa',
          where: 'id_perfil = ? AND id_recompensa = 1',
          whereArgs: [idPerfil],
        );
      }
    });
  }
}
