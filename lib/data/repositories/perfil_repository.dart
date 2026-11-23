import '../../models/perfil.dart';
import '../database/app_database.dart';

class PerfilRepository {
  final AppDatabase _db = AppDatabase.instance;

  Future<int> create(Perfil perfil) async {
    final db = await _db.database;
    return await db.insert('perfil', perfil.toMap());
  }

  Future<Perfil?> getById(int id) async {
    final db = await _db.database;
    final maps = await db.query(
      'perfil',
      where: 'id_perfil = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Perfil.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Perfil>> getByResponsavel(int idResponsavel) async {
    final db = await _db.database;
    final result = await db.query(
      'perfil',
      where: 'id_responsavel = ?',
      whereArgs: [idResponsavel],
      orderBy: 'nome ASC',
    );

    return result.map((json) => Perfil.fromMap(json)).toList();
  }

  Future<int> update(Perfil perfil) async {
    final db = await _db.database;
    return await db.update(
      'perfil',
      perfil.toMap(),
      where: 'id_perfil = ?',
      whereArgs: [perfil.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _db.database;
    return await db.delete(
      'perfil',
      where: 'id_perfil = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, dynamic>?> getPerfilComPreferencias(int idPerfil) async {
    final db = await _db.database;
    final result = await db.rawQuery('''
      SELECT p.*, ps.cor_preferida, ps.som_ativado, ps.velocidade_animacao
      FROM perfil p
      LEFT JOIN preferencia_sensorial ps ON p.id_perfil = ps.id_perfil
      WHERE p.id_perfil = ?
    ''', [idPerfil]);

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
}
